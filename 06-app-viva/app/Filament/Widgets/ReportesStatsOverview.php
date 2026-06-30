<?php

namespace App\Filament\Widgets;

use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;
use Illuminate\Support\Facades\DB;

class ReportesStatsOverview extends BaseWidget
{
    // Define el orden en el que aparecerá en el Dashboard
    protected static ?int $sort = 1;

    protected function getStats(): array
    {
        // Consultas con Query Builder
        $totalClientes = DB::table('clientes.Cliente')->count();
        
        $totalLineasActivas = DB::table('lineas.Linea')
            ->where('estado', 'Activo')
            ->count();
            
        $ingresosTotales = DB::table('finanzas.Factura')
            ->where('estado_pago', 'Pagado')
            ->sum('monto_total');

        return [
            Stat::make('Total de Clientes', number_format($totalClientes))
                ->description('Clientes registrados en el sistema')
                ->descriptionIcon('heroicon-m-users')
                ->color('primary'),
                
            Stat::make('Líneas Activas', number_format($totalLineasActivas))
                ->description('Total de líneas operativas')
                ->descriptionIcon('heroicon-m-signal')
                ->color('info'),
                
            Stat::make('Ingresos Totales', '$' . number_format($ingresosTotales, 2))
                ->description('Suma de facturas pagadas')
                ->descriptionIcon('heroicon-m-currency-dollar')
                ->color('success'),
        ];
    }
}
