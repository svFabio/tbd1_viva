<?php

namespace App\Filament\Pages;

use Filament\Pages\Page;
use Filament\Actions\Action;
use Illuminate\Support\Facades\DB;
use Filament\Notifications\Notification;
use App\Models\Bolsillo;
use App\Models\Linea;
use Carbon\Carbon;

class SimuladorTrafico extends Page
{
    protected static ?string $navigationIcon = 'heroicon-o-signal';
    protected static ?string $navigationLabel = 'Simulador de Tráfico';
    protected static ?string $title = 'Simular Uso de la Línea';
    protected static ?int $navigationSort = 3;

    protected static string $view = 'filament.pages.simulador-trafico';

    public static function canAccess(): bool
    {
        return auth()->user()->id_cliente !== null;
    }

    public function procesarTrafico($tipoActividad, $segundos)
    {
        if ($segundos <= 0) return;

        $user = auth()->user();
        $linea = Linea::where('id_cliente', $user->id_cliente)->first();
        if (!$linea) return;

        DB::beginTransaction();
        try {
            $bolsillo = Bolsillo::where('id_linea', $linea->id_linea)->lockForUpdate()->first();
            $cantidadCobrar = 0;
            $tipoConsumoDB = 'Datos';
            $mensaje = "";
            $idBolsaIlimitada = null;

            if ($tipoActividad === 'DATOS_GENERAL') {
                $cantidadCobrar = $segundos * 0.2;
                $mensaje = "Navegaste por $segundos segundos. Consumo: $cantidadCobrar MB.";
            } 
            elseif ($tipoActividad === 'VOZ') {
                $tipoConsumoDB = 'Voz';
                $cantidadCobrar = $segundos * 1; // 1 min por segundo simulado
                $mensaje = "Llamaste por $segundos min simulados.";
            } 
            elseif (in_array($tipoActividad, ['APP_WHATSAPP', 'APP_TIKTOK'])) {
                $nombreApp = ($tipoActividad === 'APP_WHATSAPP') ? 'WhatsApp' : 'TikTok';
                $tasaPorSegundo = ($tipoActividad === 'APP_WHATSAPP') ? 0.1 : 1.0;
                
                // Verificar bolsa ilimitada
                $bolsaActiva = DB::table('servicios.Bolsa_Activa')
                    ->join('servicios.App_Exenta_En_Bolsa', 'servicios.Bolsa_Activa.id_paquete', '=', 'servicios.App_Exenta_En_Bolsa.id_paquete')
                    ->where('servicios.Bolsa_Activa.id_linea', $linea->id_linea)
                    ->where('servicios.Bolsa_Activa.fecha_expiracion', '>', Carbon::now())
                    ->where('servicios.App_Exenta_En_Bolsa.nombre_app', 'ilike', '%' . $nombreApp . '%')
                    ->select('servicios.Bolsa_Activa.id_bolsa_activa')
                    ->first();

                if ($bolsaActiva) {
                    $cantidadCobrar = 0;
                    $idBolsaIlimitada = $bolsaActiva->id_bolsa_activa;
                    $mensaje = "Usaste $nombreApp por $segundos segundos. ¡Te salió 100% GRATIS!";
                } else {
                    $cantidadCobrar = $segundos * $tasaPorSegundo;
                    $mensaje = "Usaste $nombreApp sin bolsa ilimitada. Consumió $cantidadCobrar MB de tu saldo normal.";
                }
            }

            // Descontar del bolsillo
            if ($tipoConsumoDB === 'Datos') {
                if ($bolsillo->saldo_megas < $cantidadCobrar) {
                    throw new \Exception("Megas Insuficientes. Intentaste consumir $cantidadCobrar MB pero solo tienes {$bolsillo->saldo_megas} MB.");
                }
                $bolsillo->saldo_megas -= $cantidadCobrar;
            } elseif ($tipoConsumoDB === 'Voz') {
                if ($bolsillo->saldo_minutos < $cantidadCobrar) {
                    throw new \Exception("Minutos Insuficientes. Necesitas $cantidadCobrar Min pero solo tienes {$bolsillo->saldo_minutos} Min.");
                }
                $bolsillo->saldo_minutos -= $cantidadCobrar;
            }

            $bolsillo->save();

            // Registrar en tabla Consumo
            DB::table('servicios.Consumo')->insert([
                'id_linea' => $linea->id_linea,
                'tipo_consumo' => $tipoConsumoDB,
                'cantidad' => $cantidadCobrar,
                'id_bolsa_activa' => $idBolsaIlimitada,
                'fecha_consumo' => Carbon::now()
            ]);

            DB::commit();
            Notification::make()->title('Consumo Registrado')->body($mensaje)->success()->send();

        } catch (\Exception $e) {
            DB::rollBack();
            Notification::make()->title('Tráfico Detenido')->body($e->getMessage())->danger()->send();
        }
    }
}
