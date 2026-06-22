<?php

namespace App\Filament\Pages;

use Filament\Pages\Page;
use Illuminate\Support\Facades\DB;

class DashboardReportes extends Page
{
    protected static ?string $navigationIcon = 'heroicon-o-chart-bar';
    protected static ?string $navigationLabel = 'Dashboard de Reportes (BI)';
    protected static ?string $navigationGroup = 'Reportes y Analítica';
    protected static ?string $title = 'Business Intelligence VIVA';
    protected static ?string $slug = 'dashboard-reportes';

    protected static string $view = 'filament.pages.dashboard-reportes';

    public static function canAccess(): bool
    {
        $user = auth()->user();
        return $user && in_array($user->username, ['u.reporte']);
    }

    protected function getViewData(): array
    {
        // Solo como ejemplo. u.reporte tiene permisos SELECT globales.
        // Aquí aprovechamos la arquitectura leyendo de múltiples esquemas:
        
        $totalClientes = DB::table('clientes.Cliente')->count();
        $totalLineasActivas = DB::table('lineas.Linea')->where('estado', 'Activo')->count();
        $ingresosTotales = DB::table('finanzas.Factura')->where('estado_pago', 'Pagado')->sum('monto_total');
        
        return [
            'totalClientes' => $totalClientes,
            'totalLineasActivas' => $totalLineasActivas,
            'ingresosTotales' => $ingresosTotales,
        ];
    }
}
