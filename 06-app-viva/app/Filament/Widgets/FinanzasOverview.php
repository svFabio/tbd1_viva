<?php

namespace App\Filament\Widgets;

use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;
use Illuminate\Support\Facades\DB;
use App\Models\Factura;
use App\Models\Recarga;

class FinanzasOverview extends BaseWidget
{
    protected static ?int $sort = 1;

    public static function canView(): bool
    {
        return auth()->user()->rol_db === 'rol_finanzas' || auth()->user()->rol_db === 'rol_reporte';
    }

    protected function getStats(): array
    {
        // 1. Ingresos por Recargas
        $ingresosRecargas = DB::table('finanzas.Recarga')->sum('monto');

        // 2. Facturación Total Emitida
        $facturacionTotal = DB::table('finanzas.Factura')->sum('monto_total');

        // 3. Deuda Pendiente (Facturas NO pagadas)
        $deudaPendiente = DB::table('finanzas.Factura')
                            ->where('estado_pago', '!=', 'Pagado')
                            ->sum('monto_total');

        // 4. Cantidad de Préstamos Activos (T_Presta)
        $prestamosActivos = DB::table('finanzas.T_Presta')
                              ->where('estado_cobro', 'Pendiente')
                              ->sum('monto_prestado');

        return [
            Stat::make('Ingresos por Recargas', 'Bs. ' . number_format($ingresosRecargas, 2))
                ->description('Total histórico de recargas prepago')
                ->descriptionIcon('heroicon-m-arrow-trending-up')
                ->color('success'),

            Stat::make('Facturación Total', 'Bs. ' . number_format($facturacionTotal, 2))
                ->description('Facturación postpago emitida')
                ->descriptionIcon('heroicon-m-document-text')
                ->color('primary'),

            Stat::make('Deuda por Cobrar', 'Bs. ' . number_format($deudaPendiente, 2))
                ->description('Facturas en mora o pendientes')
                ->descriptionIcon('heroicon-m-exclamation-circle')
                ->color('danger'),
                
            Stat::make('Préstamos T-Presta', 'Bs. ' . number_format($prestamosActivos, 2))
                ->description('Monto prestado pendiente de cobro')
                ->descriptionIcon('heroicon-m-banknotes')
                ->color('warning'),
        ];
    }
}
