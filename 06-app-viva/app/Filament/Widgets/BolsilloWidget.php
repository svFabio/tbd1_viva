<?php

namespace App\Filament\Widgets;

use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;
use App\Models\Linea;
use App\Models\Bolsillo;

class BolsilloWidget extends BaseWidget
{
    protected static ?string $pollingInterval = '10s';

    public static function canView(): bool
    {
        return auth()->user()->id_cliente !== null;
    }

    protected function getStats(): array
    {
        $user = auth()->user();

        // 1. Encontrar la línea del usuario actual
        $linea = Linea::where('id_cliente', $user->id_cliente)->first();

        if (!$linea) {
            return [
                Stat::make('Estado de Línea', 'Sin línea asignada')
                    ->description('Acércate a un punto Viva para activar tu línea')
                    ->color('danger'),
            ];
        }

        // 2. Encontrar el bolsillo asociado a esa línea
        $bolsillo = Bolsillo::where('id_linea', $linea->id_linea)->first();

        if (!$bolsillo) {
            return [
                Stat::make('Bolsillo', 'No inicializado')
                    ->description('Línea: ' . $linea->numero_telefono)
                    ->color('warning'),
            ];
        }

        // 3. Obtener la fecha de caducidad más lejana de todos los paquetes activos
        $maxFechaExpiracion = \Illuminate\Support\Facades\DB::table('servicios.Bolsa_Activa')
            ->where('id_linea', $linea->id_linea)
            ->where('fecha_expiracion', '>', \Carbon\Carbon::now())
            ->max('fecha_expiracion');

        $vencimientoTexto = $maxFechaExpiracion 
            ? 'Vence: ' . \Carbon\Carbon::parse($maxFechaExpiracion)->format('d/m/Y H:i') 
            : 'Sin paquetes vigentes (Saldos inactivos)';

        // Si no hay paquetes vigentes, el saldo se congela o pierde (mostramos 0)
        $megas = $maxFechaExpiracion ? $bolsillo->saldo_megas : 0;
        $minutos = $maxFechaExpiracion ? $bolsillo->saldo_minutos : 0;
        $sms = $maxFechaExpiracion ? $bolsillo->saldo_sms : 0;

        // Si los saldos caducaron, podemos resetearlos en BD por limpieza (opcional)
        if (!$maxFechaExpiracion && ($bolsillo->saldo_megas > 0 || $bolsillo->saldo_minutos > 0 || $bolsillo->saldo_sms > 0)) {
            $bolsillo->saldo_megas = 0;
            $bolsillo->saldo_minutos = 0;
            $bolsillo->saldo_sms = 0;
            $bolsillo->save();
        }

        // 4. Devolver las estadísticas en formato bonito
        return [
            Stat::make('Crédito Disponible', 'Bs. ' . number_format($bolsillo->saldo_dinero, 2))
                ->description('Para compras y renovaciones')
                ->descriptionIcon('heroicon-m-currency-dollar')
                ->color('success'),

            Stat::make('Megas Disponibles', number_format($megas, 0) . ' MB')
                ->description($megas > 0 ? $vencimientoTexto : 'Sin megas')
                ->icon('heroicon-o-globe-alt')
                ->color($megas > 0 ? 'primary' : 'gray'),
            
            Stat::make('Minutos Disponibles', number_format($minutos, 0) . ' Min')
                ->description($minutos > 0 ? $vencimientoTexto : 'Sin minutos')
                ->icon('heroicon-o-phone')
                ->color($minutos > 0 ? 'success' : 'gray'),

            Stat::make('SMS Disponibles', number_format($sms, 0) . ' SMS')
                ->description($sms > 0 ? $vencimientoTexto : 'Sin SMS')
                ->icon('heroicon-o-chat-bubble-oval-left-ellipsis')
                ->color($sms > 0 ? 'warning' : 'gray'),
        ];
    }
}
