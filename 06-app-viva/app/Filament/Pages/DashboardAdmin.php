<?php

namespace App\Filament\Pages;

use Filament\Pages\Page;
use Illuminate\Support\Facades\DB;

class DashboardAdmin extends Page
{
    protected static ?string $navigationIcon = 'heroicon-o-shield-check';
    protected static ?string $navigationLabel = 'Panel de Administración';
    protected static ?string $navigationGroup = 'Administración';
    protected static ?string $title = 'Dashboard Administrativo';
    protected static ?string $slug = 'dashboard-admin';
    protected static ?int $navigationSort = -2;

    protected static string $view = 'filament.pages.dashboard-admin';

    /**
     * Solo visible para usuarios administrativos (sin id_cliente),
     * cuyo rol_db NO sea 'rol_app'.
     */
    public static function canAccess(): bool
    {
        $user = auth()->user();
        return $user
            && $user->id_cliente === null
            && $user->rol_db !== 'rol_app';
    }

    protected function getViewData(): array
    {
        $user = auth()->user();

        // ── 1. Datos del usuario autenticado (directo de BD, sin hardcodear) ──
        $username   = $user->username;
        $rolDb      = $user->rol_db;
        $displayName = $user->getFilamentName(); // ya resuelve nombre real

        // ── 2. Mapeo de rol_db → nombre legible para la UI ──
        // Leemos la descripción del rol directamente desde pg_roles de PostgreSQL
        $rolInfo = DB::selectOne("
            SELECT r.rolname,
                   r.rolcanlogin,
                   r.rolinherit,
                   r.rolsuper,
                   r.rolcreatedb,
                   r.rolcreaterole,
                   r.rolbypassrls,
                   r.rolvaliduntil
            FROM pg_catalog.pg_roles r
            WHERE r.rolname = ?
        ", [$rolDb]);

        // Mapeo de nombres legibles (construido desde la arquitectura de 01-roles.sql)
        // Usamos colores hex para poder aplicarlos como inline-styles (Tailwind purga clases dinámicas)
        $rolesLegibles = [
            'rol_comercial' => ['nombre' => 'Comercial',   'icono' => '📊', 'hex' => '#2563eb', 'hexLight' => '#dbeafe', 'descripcion' => 'Gestión de promociones, fidelización y paquetes comerciales'],
            'rol_auditor'   => ['nombre' => 'Auditor',     'icono' => '🔍', 'hex' => '#dc2626', 'hexLight' => '#fee2e2', 'descripcion' => 'Supervisión de seguridad, auditoría y cumplimiento normativo'],
            'rol_agencia'   => ['nombre' => 'Agencia',     'icono' => '🏢', 'hex' => '#059669', 'hexLight' => '#d1fae5', 'descripcion' => 'Alta de clientes, venta de líneas y administración de SIMs'],
            'rol_finanzas'  => ['nombre' => 'Finanzas',    'icono' => '💰', 'hex' => '#d97706', 'hexLight' => '#fef3c7', 'descripcion' => 'Control financiero: facturas, recargas, préstamos y bolsillos'],
            'rol_reporte'   => ['nombre' => 'Reportes BI', 'icono' => '📈', 'hex' => '#7c3aed', 'hexLight' => '#ede9fe', 'descripcion' => 'Inteligencia de negocios con acceso analítico multi-esquema (solo lectura)'],
        ];

        $rolMeta = $rolesLegibles[$rolDb] ?? [
            'nombre' => ucfirst(str_replace('rol_', '', $rolDb)),
            'icono'  => '👤',
            'hex'    => '#6b7280',
            'hexLight' => '#f3f4f6',
            'descripcion' => 'Rol del sistema',
        ];

        // ── 3. Esquemas y tablas a los que tiene acceso este rol (dinámico desde PG) ──
        $permisosTablas = DB::select("
            SELECT table_schema,
                   table_name,
                   STRING_AGG(DISTINCT privilege_type, ', ' ORDER BY privilege_type) AS privilegios
            FROM information_schema.role_table_grants
            WHERE grantee = ?
              AND table_schema NOT IN ('pg_catalog', 'information_schema')
            GROUP BY table_schema, table_name
            ORDER BY table_schema, table_name
        ", [$rolDb]);

        // Agrupar por esquema
        $permisosPorEsquema = [];
        foreach ($permisosTablas as $p) {
            $permisosPorEsquema[$p->table_schema][] = [
                'tabla'       => $p->table_name,
                'privilegios' => $p->privilegios,
            ];
        }

        // ── 4. Otros usuarios admin del sistema (para contexto, sin mostrar passwords) ──
        $otrosAdmins = collect([]);
        try {
            $otrosAdmins = DB::table('seguridad.Usuario_Sistema')
                ->whereNull('id_cliente')
                ->where('rol_db', '!=', 'rol_app')
                ->select('id_usuario', 'username', 'rol_db')
                ->orderBy('rol_db')
                ->get();
        } catch (\Exception $e) {
            // El usuario actual no tiene permisos para ver seguridad.Usuario_Sistema
        }

        // ── 5. Contadores rápidos según el rol ──
        $estadisticas = $this->getEstadisticasPorRol($rolDb);

        return [
            'username'           => $username,
            'displayName'        => $displayName,
            'rolDb'              => $rolDb,
            'rolMeta'            => $rolMeta,
            'rolInfo'            => $rolInfo,
            'permisosPorEsquema' => $permisosPorEsquema,
            'otrosAdmins'        => $otrosAdmins,
            'rolesLegibles'      => $rolesLegibles,
            'estadisticas'       => $estadisticas,
        ];
    }

    /**
     * Estadísticas dinámicas según el rol del usuario.
     * Solo consulta tablas a las que el rol tiene acceso real en PG.
     */
    private function getEstadisticasPorRol(string $rol): array
    {
        $stats = [];

        try {
            switch ($rol) {
                case 'rol_comercial':
                    $stats['Promociones Activas']  = DB::table('comercial.Promocion')->count();
                    $stats['Paquetes Disponibles']  = DB::table('servicios.Paquete')->count();
                    $stats['Condiciones de Puntos'] = DB::table('fidelizacion.Condicion_Puntos')->count();
                    break;

                case 'rol_auditor':
                    $stats['Registros de Auditoría'] = DB::table('seguridad.Auditoria')->count();
                    $stats['Usuarios del Sistema']   = DB::table('seguridad.Usuario_Sistema')->count();
                    $stats['Transacciones Totales']   = DB::table('finanzas.Transaccion')->count();
                    break;

                case 'rol_agencia':
                    $stats['Clientes Registrados'] = DB::table('clientes.Cliente')->count();
                    $stats['Líneas Activas']       = DB::table('lineas.Linea')->where('estado', 'Activa')->count();
                    $stats['SIMs Disponibles']     = DB::table('lineas.SIM_Card')->where('estado', 'Disponible')->count();
                    break;

                case 'rol_finanzas':
                    $stats['Facturas Emitidas']     = DB::table('finanzas.Factura')->count();
                    $stats['Recargas Realizadas']    = DB::table('finanzas.Recarga')->count();
                    $stats['Préstamos Pendientes']   = DB::table('finanzas.T_Presta')->where('estado_cobro', 'Pendiente')->count();
                    break;

                case 'rol_reporte':
                    $stats['Clientes Totales']    = DB::table('clientes.Cliente')->count();
                    $stats['Líneas Registradas']  = DB::table('lineas.Linea')->count();
                    $stats['Ingresos por Facturación'] = 'Bs. ' . number_format(
                        (float) DB::table('finanzas.Factura')->sum('monto_total'), 2
                    );
                    break;
            }
        } catch (\Exception $e) {
            $stats['Error'] = 'Sin acceso a estadísticas: ' . $e->getMessage();
        }

        return $stats;
    }
}
