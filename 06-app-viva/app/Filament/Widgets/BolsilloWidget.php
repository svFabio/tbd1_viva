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

        // 3. Obtener la fecha de caducidad por tipo de beneficio
        $maxFechaMegas = \Illuminate\Support\Facades\DB::table('servicios.Bolsa_Activa')
            ->join('servicios.Paquete', 'servicios.Bolsa_Activa.id_paquete', '=', 'servicios.Paquete.id_paquete')
            ->where('servicios.Bolsa_Activa.id_linea', $linea->id_linea)
            ->where('servicios.Bolsa_Activa.fecha_expiracion', '>', \Carbon\Carbon::now())
            ->where('servicios.Paquete.megas', '>', 0)
            ->max('servicios.Bolsa_Activa.fecha_expiracion');

        $maxFechaMinutos = \Illuminate\Support\Facades\DB::table('servicios.Bolsa_Activa')
            ->join('servicios.Paquete', 'servicios.Bolsa_Activa.id_paquete', '=', 'servicios.Paquete.id_paquete')
            ->where('servicios.Bolsa_Activa.id_linea', $linea->id_linea)
            ->where('servicios.Bolsa_Activa.fecha_expiracion', '>', \Carbon\Carbon::now())
            ->where('servicios.Paquete.minutos', '>', 0)
            ->max('servicios.Bolsa_Activa.fecha_expiracion');

        $maxFechaSms = \Illuminate\Support\Facades\DB::table('servicios.Bolsa_Activa')
            ->join('servicios.Paquete', 'servicios.Bolsa_Activa.id_paquete', '=', 'servicios.Paquete.id_paquete')
            ->where('servicios.Bolsa_Activa.id_linea', $linea->id_linea)
            ->where('servicios.Bolsa_Activa.fecha_expiracion', '>', \Carbon\Carbon::now())
            ->where('servicios.Paquete.sms', '>', 0)
            ->max('servicios.Bolsa_Activa.fecha_expiracion');

        $vencimientoMegas = $maxFechaMegas ? 'Vence: ' . \Carbon\Carbon::parse($maxFechaMegas)->format('d/m/Y H:i') : 'Sin megas';
        $vencimientoMinutos = $maxFechaMinutos ? 'Vence: ' . \Carbon\Carbon::parse($maxFechaMinutos)->format('d/m/Y H:i') : 'Sin minutos';
        $vencimientoSms = $maxFechaSms ? 'Vence: ' . \Carbon\Carbon::parse($maxFechaSms)->format('d/m/Y H:i') : 'Sin SMS';

        // Si no hay paquetes vigentes que den ese beneficio, el saldo se asume 0
        $megas = $maxFechaMegas ? $bolsillo->saldo_megas : 0;
        $minutos = $maxFechaMinutos ? $bolsillo->saldo_minutos : 0;
        $sms = $maxFechaSms ? $bolsillo->saldo_sms : 0;

        // Limpieza BD (si un beneficio caducó, se borra su saldo independientemente)
        $guardar = false;
        if (!$maxFechaMegas && $bolsillo->saldo_megas > 0) { $bolsillo->saldo_megas = 0; $guardar = true; }
        if (!$maxFechaMinutos && $bolsillo->saldo_minutos > 0) { $bolsillo->saldo_minutos = 0; $guardar = true; }
        if (!$maxFechaSms && $bolsillo->saldo_sms > 0) { $bolsillo->saldo_sms = 0; $guardar = true; }
        if ($guardar) { $bolsillo->save(); }

        // 4. Devolver las estadísticas en formato bonito
        return [
            Stat::make('Crédito Disponible', 'Bs. ' . number_format($bolsillo->saldo_dinero, 2))
                ->description('Para compras y renovaciones')
                ->descriptionIcon('heroicon-m-currency-dollar')
                ->color('success'),

            Stat::make('Megas Disponibles', number_format($megas, 0) . ' MB')
                ->description($vencimientoMegas)
                ->icon('heroicon-o-globe-alt')
                ->color($megas > 0 ? 'primary' : 'gray'),
            
            Stat::make('Minutos Disponibles', number_format($minutos, 0) . ' Min')
                ->description($vencimientoMinutos)
                ->icon('heroicon-o-phone')
                ->color($minutos > 0 ? 'success' : 'gray'),

            Stat::make('SMS Disponibles', number_format($sms, 0) . ' SMS')
                ->description($vencimientoSms)
                ->icon('heroicon-o-chat-bubble-oval-left-ellipsis')
                ->color($sms > 0 ? 'warning' : 'gray'),
        ];
    }
}
