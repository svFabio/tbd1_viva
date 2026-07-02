<?php

namespace App\Filament\Widgets;

use Filament\Widgets\ChartWidget;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class IngresosMensualesChart extends ChartWidget
{
    protected static ?string $heading = 'Ingresos Mensuales (Últimos 6 meses)';
    protected static ?int $sort = 2;

    // Solo visible para el rol de reportes BI
    public static function canView(): bool
    {
        return auth()->user()?->rol_db === 'rol_reporte';
    }

    protected function getData(): array
    {
        $ingresos = [];
        $meses = [];

        // Recorremos los últimos 6 meses (de más antiguo a más reciente)
        for ($i = 5; $i >= 0; $i--) {
            $fecha = Carbon::now()->subMonths($i);
            
            $inicioMes = $fecha->copy()->startOfMonth()->toDateString();
            $finMes = $fecha->copy()->endOfMonth()->toDateString();

            // Consulta de agregación estricta con Query Builder
            $totalMes = DB::table('finanzas.Factura')
                ->where('estado_pago', 'Pagado')
                ->whereBetween('fecha_emision', [$inicioMes, $finMes])
                ->sum('monto_total');

            $ingresos[] = (float) $totalMes;
            // Guardamos el nombre del mes y año para la etiqueta (ej. "Enero 2024")
            $meses[] = ucfirst($fecha->translatedFormat('F Y')); 
        }

        return [
            'datasets' => [
                [
                    'label' => 'Ingresos ($)',
                    'data' => $ingresos,
                    'borderColor' => '#10b981', // Verde esmeralda (Success)
                    'backgroundColor' => 'rgba(16, 185, 129, 0.2)',
                    'fill' => 'start',
                ],
            ],
            'labels' => $meses,
        ];
    }

    protected function getType(): string
    {
        return 'line';
    }
}
