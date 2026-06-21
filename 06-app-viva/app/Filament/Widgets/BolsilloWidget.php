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
        return [
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
    }
}
