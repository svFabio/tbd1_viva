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

        // 3. Devolver las estadísticas en formato bonito
        $stats = [
            Stat::make('Crédito Disponible', 'Bs. ' . number_format($bolsillo->saldo_dinero, 2))
                ->description('Línea: ' . $linea->numero_telefono)
                ->descriptionIcon('heroicon-m-currency-dollar')
                ->color('success'),

            Stat::make('Megas Disponibles', number_format($bolsillo->saldo_megas, 0) . ' MB')
                ->description('Para navegar')
                ->icon('heroicon-o-globe-alt')
                ->color('primary'),
            
            Stat::make('Minutos Disponibles', number_format($bolsillo->saldo_minutos, 0) . ' Min')
                ->description('Para llamadas')
                ->icon('heroicon-o-phone')
                ->color('success'),

            Stat::make('SMS Disponibles', number_format($bolsillo->saldo_sms ?? 0, 0) . ' SMS')
                ->description('Mensajes de texto')
                ->icon('heroicon-o-chat-bubble-oval-left-ellipsis')
                ->color('warning'),
        ];

        // 4. Buscar paquetes ilimitados activos (Bolsas Activas)
        $bolsasActivas = \Illuminate\Support\Facades\DB::table('servicios.Bolsa_Activa')
            ->join('servicios.Paquete', 'servicios.Bolsa_Activa.id_paquete', '=', 'servicios.Paquete.id_paquete')
            ->where('servicios.Bolsa_Activa.id_linea', $linea->id_linea)
            ->where('servicios.Bolsa_Activa.fecha_expiracion', '>', \Carbon\Carbon::now())
            ->get();

        foreach ($bolsasActivas as $bolsa) {
            $stats[] = Stat::make('Paquete Activo', $bolsa->nombre_paquete)
                ->description('Vence: ' . \Carbon\Carbon::parse($bolsa->fecha_expiracion)->format('d/m/Y H:i'))
                ->icon('heroicon-o-sparkles')
                ->color('success');
        }

        return $stats;
    }
}
