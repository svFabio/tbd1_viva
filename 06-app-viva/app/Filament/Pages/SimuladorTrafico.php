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
                $cantidadCobrar = $segundos * 1.0;
                $mensaje = "Navegaste por $segundos segundos. Consumo: $cantidadCobrar MB.";
            }
            elseif ($tipoActividad === 'VOZ') {
                $tipoConsumoDB = 'Voz';
                $cantidadCobrar = $segundos * 1; // 1 min por segundo simulado
                $mensaje = "Llamaste por $segundos min simulados.";
            }
            elseif (str_starts_with($tipoActividad, 'APP_')) {
                // ── Lógica dinámica: el nombre de la app viene del frontend como
                //    "APP_WHATSAPP", "APP_TIKTOK", "APP_NETFLIX", etc.
                //    Lo convertimos a texto legible para buscar en la BD.
                $nombreApp = ucfirst(strtolower(substr($tipoActividad, 4)));
                // Tasa por defecto: 1 MB/s para apps de video, 0.1 MB/s para mensajería
                // El comercial controla qué apps existen — la tasa no se hardcodea por app.
                $tasaPorSegundo = 1.0;

                // ── Consulta dinámica: busca en BD si el usuario tiene una bolsa activa
                //    que incluya esta app como exenta (sin importar qué app sea)
                $bolsaActiva = DB::table('servicios.Bolsa_Activa')
                    ->join(
                        'servicios.App_Exenta_En_Bolsa',
                        'servicios.Bolsa_Activa.id_paquete',
                        '=',
                        'servicios.App_Exenta_En_Bolsa.id_paquete'
                    )
                    ->where('servicios.Bolsa_Activa.id_linea', $linea->id_linea)
                    ->where('servicios.Bolsa_Activa.fecha_expiracion', '>', Carbon::now())
                    ->where('servicios.App_Exenta_En_Bolsa.nombre_app', 'ilike', '%' . $nombreApp . '%')
                    ->select(
                        'servicios.Bolsa_Activa.id_bolsa_activa',
                        'servicios.App_Exenta_En_Bolsa.nombre_app as nombre_real'
                    )
                    ->first();

                if ($bolsaActiva) {
                    $cantidadCobrar = 0;
                    $idBolsaIlimitada = $bolsaActiva->id_bolsa_activa;
                    $nombreReal = $bolsaActiva->nombre_real;
                    $mensaje = "Usaste $nombreReal por $segundos segundos. ¡Te salió 100% GRATIS (bolsa ilimitada activa)!";
                } else {
                    $cantidadCobrar = $segundos * $tasaPorSegundo;
                    $mensaje = "Usaste $nombreApp por $segundos segundos sin bolsa ilimitada. Consumió $cantidadCobrar MB de tu saldo normal.";
                }
            }

            // Descontar del bolsillo (Bolsillo usa enteros, así que redondeamos)
            if ($tipoConsumoDB === 'Datos') {
                $cobroBolsillo = (int) ceil($cantidadCobrar); // Si gastas 0.2 MB, te cobra 1 MB
                if ($bolsillo->saldo_megas < $cobroBolsillo) {
                    throw new \Exception("Megas Insuficientes. Intentaste consumir $cantidadCobrar MB pero solo tienes {$bolsillo->saldo_megas} MB.");
                }
                $bolsillo->saldo_megas -= $cobroBolsillo;
            } elseif ($tipoConsumoDB === 'Voz') {
                $cobroBolsillo = (int) ceil($cantidadCobrar);
                if ($bolsillo->saldo_minutos < $cobroBolsillo) {
                    throw new \Exception("Minutos Insuficientes. Necesitas $cantidadCobrar Min pero solo tienes {$bolsillo->saldo_minutos} Min.");
                }
                $bolsillo->saldo_minutos -= $cobroBolsillo;
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

    public function procesarSms($longitudMensaje)
    {
        if ($longitudMensaje <= 0) return;

        $user = auth()->user();
        $linea = Linea::where('id_cliente', $user->id_cliente)->first();
        if (!$linea) return;

        DB::beginTransaction();
        try {
            $bolsillo = Bolsillo::where('id_linea', $linea->id_linea)->lockForUpdate()->first();
            
            // 1 SMS = 160 caracteres
            $cantidadSms = (int) ceil($longitudMensaje / 160);

            if ($bolsillo->saldo_sms >= $cantidadSms) {
                // Descuenta de la bolsa
                $bolsillo->saldo_sms -= $cantidadSms;
                $mensaje = "Enviaste un mensaje de $longitudMensaje letras. Te descontamos $cantidadSms SMS de tu paquete.";
            } else {
                // Descuenta en dinero
                $costoEnDinero = $cantidadSms * 0.20;
                if ($bolsillo->saldo_dinero < $costoEnDinero) {
                    throw new \Exception("¡Crédito Insuficiente! Necesitas $costoEnDinero Bs para enviar $cantidadSms SMS (no tienes paquete de SMS).");
                }
                $bolsillo->saldo_dinero -= $costoEnDinero;
                $mensaje = "No tienes bolsa de SMS activa. Te cobramos $costoEnDinero Bs por enviar $cantidadSms SMS.";
            }

            $bolsillo->save();

            // Registrar en tabla Consumo
            DB::table('servicios.Consumo')->insert([
                'id_linea' => $linea->id_linea,
                'tipo_consumo' => 'SMS',
                'cantidad' => $cantidadSms,
                'fecha_consumo' => Carbon::now()
            ]);

            DB::commit();
            Notification::make()->title('SMS Enviado')->body($mensaje)->success()->send();

        } catch (\Exception $e) {
            DB::rollBack();
            Notification::make()->title('Error al enviar SMS')->body($e->getMessage())->danger()->send();
        }
    }
}
