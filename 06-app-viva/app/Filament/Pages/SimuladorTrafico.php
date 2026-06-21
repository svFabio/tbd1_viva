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

    protected function getHeaderActions(): array
    {
        return [
            Action::make('navegar')
                ->label('Navegar por Internet (Gasta 50 MB)')
                ->color('primary')
                ->icon('heroicon-o-globe-alt')
                ->action(fn () => $this->simularConsumo('DATOS', 50, 'Navegaste por internet viendo memes.')),
                
            Action::make('llamar')
                ->label('Llamar a tu mamá (Gasta 5 Min)')
                ->color('success')
                ->icon('heroicon-o-phone')
                ->action(fn () => $this->simularConsumo('VOZ', 5, 'Llamaste a tu mamá. ¡Qué buen hijo!')),

            Action::make('whatsapp')
                ->label('Mandar WhatsApp')
                ->color('success')
                ->icon('heroicon-o-chat-bubble-left-right')
                ->action(fn () => $this->simularApp('WhatsApp', 10)),

            Action::make('tiktok')
                ->label('Ver videos en TikTok')
                ->color('danger')
                ->icon('heroicon-o-video-camera')
                ->action(fn () => $this->simularApp('TikTok', 100)),
        ];
    }

    private function simularConsumo($tipo, $cantidad, $mensajeExito)
    {
        $user = auth()->user();
        $linea = Linea::where('id_cliente', $user->id_cliente)->first();
        if (!$linea) return;

        DB::beginTransaction();
        try {
            $bolsillo = Bolsillo::where('id_linea', $linea->id_linea)->lockForUpdate()->first();

            if ($tipo === 'DATOS') {
                if ($bolsillo->saldo_megas < $cantidad) {
                    throw new \Exception("No tienes suficientes Megas. Te faltan " . ($cantidad - $bolsillo->saldo_megas) . " MB.");
                }
                $bolsillo->saldo_megas -= $cantidad;
            } elseif ($tipo === 'VOZ') {
                if ($bolsillo->saldo_minutos < $cantidad) {
                    throw new \Exception("No tienes suficientes Minutos. Te faltan " . ($cantidad - $bolsillo->saldo_minutos) . " Min.");
                }
                $bolsillo->saldo_minutos -= $cantidad;
            }

            $bolsillo->save();

            DB::table('servicios.Consumo')->insert([
                'id_linea' => $linea->id_linea,
                'tipo_consumo' => $tipo,
                'cantidad' => $cantidad,
                'fecha_consumo' => Carbon::now()
            ]);

            DB::commit();

            Notification::make()->title('Éxito')->body($mensajeExito)->success()->send();

        } catch (\Exception $e) {
            DB::rollBack();
            Notification::make()->title('Saldo Insuficiente')->body($e->getMessage())->danger()->send();
        }
    }

    private function simularApp($nombreApp, $megasSiNoEsGratis)
    {
        $user = auth()->user();
        $linea = Linea::where('id_cliente', $user->id_cliente)->first();
        if (!$linea) return;

        // 1. Verificamos si tiene la App Ilimitada activa
        $bolsaActiva = DB::table('servicios.Bolsa_Activa')
            ->join('servicios.App_Exenta_En_Bolsa', 'servicios.Bolsa_Activa.id_paquete', '=', 'servicios.App_Exenta_En_Bolsa.id_paquete')
            ->where('servicios.Bolsa_Activa.id_linea', $linea->id_linea)
            ->where('servicios.Bolsa_Activa.fecha_expiracion', '>', Carbon::now())
            ->where('servicios.App_Exenta_En_Bolsa.nombre_app', 'ilike', '%' . $nombreApp . '%')
            ->select('servicios.Bolsa_Activa.id_bolsa_activa')
            ->first();

        if ($bolsaActiva) {
            // Tiene la app ilimitada
            DB::table('servicios.Consumo')->insert([
                'id_linea' => $linea->id_linea,
                'tipo_consumo' => strtoupper($nombreApp) . '_ILIMITADO',
                'cantidad' => 0,
                'id_bolsa_activa' => $bolsaActiva->id_bolsa_activa,
                'fecha_consumo' => Carbon::now()
            ]);

            Notification::make()
                ->title('¡Ilimitado!')
                ->body("Usaste $nombreApp gratis gracias a tu paquete activo.")
                ->success()
                ->send();
        } else {
            // No tiene la app ilimitada, le cobramos megas normales
            $this->simularConsumo('DATOS', $megasSiNoEsGratis, "Usaste $nombreApp pero NO lo tienes ilimitado. Te descontamos $megasSiNoEsGratis MB.");
        }
    }
}
