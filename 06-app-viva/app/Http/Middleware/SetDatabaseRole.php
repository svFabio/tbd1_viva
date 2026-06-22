<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Symfony\Component\HttpFoundation\Response;

class SetDatabaseRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        // Solo ejecutamos si la conexión principal es postgres (superuser)
        // para poder bajar los privilegios dinámicamente.
        if (config('database.connections.pgsql.username') === 'postgres') {
            
            // Intentar obtener el usuario de múltiples formas (por si usa guard custom de Filament)
            $user = null;
            if (class_exists(\Filament\Facades\Filament::class) && \Filament\Facades\Filament::auth()->check()) {
                $user = \Filament\Facades\Filament::auth()->user();
            } elseif (auth()->check()) {
                $user = auth()->user();
            }

            if ($user) {
                
                // Mapeo dinámico de Usuario Web a Rol de Base de Datos
                if ($user->username === 'admin.promo') {
                    DB::statement("SET ROLE rol_admin_promo");
                } elseif ($user->username === 'u.auditor') {
                    DB::statement("SET ROLE rol_auditor");
                } elseif ($user->username === 'u.finanzas') {
                    DB::statement("SET ROLE rol_finanzas");
                } elseif ($user->username === 'u.reporte') {
                    DB::statement("SET ROLE rol_reporte");
                } else {
                    // Cliente normal
                    DB::statement("SET ROLE rol_app");
                }
                
                // INYECTAR EL USUARIO FÍSICO PARA LA AUDITORÍA
                DB::statement("SET app.current_web_user = '{$user->username}'");
                
                // CONEXIÓN PERFECTA CON TU RLS DE POSTGRESQL:
                if ($user->id_cliente) {
                    // Buscamos la línea principal del cliente
                    $linea = DB::table('lineas.Linea')
                        ->where('id_cliente', $user->id_cliente)
                        ->first();
                        
                    if ($linea) {
                        DB::statement("SET app.current_linea_id = '{$linea->id_linea}'");
                    }
                }

            } else {
                // Visitantes anónimos (Login) se bajan a rol_app por seguridad
                DB::statement("SET ROLE rol_app");
            }
        }

        return $next($request);
    }
}
