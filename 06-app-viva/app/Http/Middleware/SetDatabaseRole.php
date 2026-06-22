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
        // Solo ejecutamos si la conexión principal es postgres o u_admin_web
        // para poder bajar/asignar los privilegios dinámicamente.
        $dbUser = config('database.connections.pgsql.username');
        if ($dbUser === 'postgres' || $dbUser === 'u_admin_web') {
            
            // Intentar obtener el usuario de múltiples formas (por si usa guard custom de Filament)
            $user = null;
            if (class_exists(\Filament\Facades\Filament::class) && \Filament\Facades\Filament::auth()->check()) {
                $user = \Filament\Facades\Filament::auth()->user();
            } elseif (auth()->check()) {
                $user = auth()->user();
            }

            if ($user) {
                
                \Illuminate\Support\Facades\Log::info("SetDatabaseRole: Logged in user detected. Username is: '{$user->username}'");

                // Mapeo dinámico de Usuario Web a Rol de Base de Datos
                if (trim($user->username) === 'admin.promo') {
                    DB::statement("SET ROLE rol_admin_promo");
                    \Illuminate\Support\Facades\Log::info("SetDatabaseRole: SET ROLE rol_admin_promo executed");
                } elseif (trim($user->username) === 'u.auditor') {
                    DB::statement("SET ROLE rol_auditor");
                    \Illuminate\Support\Facades\Log::info("SetDatabaseRole: SET ROLE rol_auditor executed");
                } elseif (trim($user->username) === 'u.finanzas') {
                    DB::statement("SET ROLE rol_finanzas");
                    \Illuminate\Support\Facades\Log::info("SetDatabaseRole: SET ROLE rol_finanzas executed");
                } elseif (trim($user->username) === 'u.reporte') {
                    DB::statement("SET ROLE rol_reporte");
                    \Illuminate\Support\Facades\Log::info("SetDatabaseRole: SET ROLE rol_reporte executed");
                } else {
                    // Cliente normal
                    DB::statement("SET ROLE rol_app");
                    \Illuminate\Support\Facades\Log::info("SetDatabaseRole: SET ROLE rol_app executed (fell to else)");
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
                \Illuminate\Support\Facades\Log::info("SetDatabaseRole: No user detected in Auth check. Falling back to rol_app");
                // Visitantes anónimos (Login) se bajan a rol_app por seguridad
                DB::statement("SET ROLE rol_app");
            }
        }

        return $next($request);
    }
}
