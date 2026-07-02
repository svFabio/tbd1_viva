<x-filament-panels::page>
    {{-- ═══════════════════════════════════════════════════════
         SECCIÓN 1 — BANNER DE BIENVENIDA CON ROL
    ═══════════════════════════════════════════════════════ --}}
    <div class="relative overflow-hidden rounded-2xl p-8 text-white shadow-2xl" style="background: linear-gradient(135deg, {{ $rolMeta['hex'] }}, {{ $rolMeta['hex'] }}dd, {{ $rolMeta['hex'] }}99);">
        {{-- Decoración de fondo --}}
        <div class="absolute -right-8 -top-8 h-40 w-40 rounded-full bg-white/10 blur-2xl"></div>
        <div class="absolute -bottom-10 -left-10 h-48 w-48 rounded-full bg-white/5 blur-3xl"></div>

        <div class="relative flex flex-col sm:flex-row items-start sm:items-center gap-6">
            {{-- Ícono del Rol --}}
            <div class="flex h-20 w-20 items-center justify-center rounded-2xl bg-white/20 text-4xl backdrop-blur-sm shadow-lg" style="box-shadow: 0 0 0 2px rgba(255,255,255,0.3);">
                {{ $rolMeta['icono'] }}
            </div>

            <div class="flex-1">
                <p class="text-sm font-medium text-white/70 uppercase tracking-widest">Sesión activa como</p>
                <h1 class="text-3xl font-black tracking-tight mt-1">{{ $displayName }}</h1>
                <div class="mt-3 flex flex-wrap items-center gap-3">
                    <span class="inline-flex items-center gap-1.5 rounded-full bg-white/20 px-4 py-1.5 text-sm font-semibold backdrop-blur-sm" style="box-shadow: 0 0 0 1px rgba(255,255,255,0.3);">
                        <svg class="h-3.5 w-3.5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd"/></svg>
                        {{ $username }}
                    </span>
                    <span class="inline-flex items-center gap-1.5 rounded-full bg-white/25 px-4 py-1.5 text-sm font-bold backdrop-blur-sm" style="box-shadow: 0 0 0 1px rgba(255,255,255,0.4);">
                        <svg class="h-3.5 w-3.5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944 11.954 11.954 0 0017.834 5c.11.65.166 1.32.166 2.001 0 5.225-3.34 9.67-8 11.317C5.34 16.67 2 12.225 2 7c0-.682.057-1.35.166-2.001zm11.541 3.708a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
                        Rol: {{ $rolMeta['nombre'] }}
                    </span>
                    <span class="inline-flex items-center gap-1.5 rounded-full bg-white/15 px-4 py-1.5 text-xs font-mono backdrop-blur-sm" style="box-shadow: 0 0 0 1px rgba(255,255,255,0.2);">
                        PostgreSQL: {{ $rolDb }}
                    </span>
                </div>
                <p class="mt-3 text-sm text-white/70 leading-relaxed">{{ $rolMeta['descripcion'] }}</p>
            </div>
        </div>
    </div>

    {{-- ═══════════════════════════════════════════════════════
         SECCIÓN 2 — ESTADÍSTICAS RÁPIDAS DEL ROL
    ═══════════════════════════════════════════════════════ --}}
    @if(count($estadisticas) > 0)
    <div class="mt-6">
        <h2 class="text-lg font-bold text-gray-800 dark:text-gray-100 mb-4 flex items-center gap-2">
            <svg class="h-5 w-5" style="color: {{ $rolMeta['hex'] }};" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/></svg>
            Resumen operativo &mdash; {{ $rolMeta['nombre'] }}
        </h2>
        {{-- Grid inline para evitar problemas con JIT de Tailwind en Filament --}}
        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem;">
            @foreach($estadisticas as $label => $valor)
            <div class="group relative overflow-hidden rounded-xl bg-white dark:bg-gray-800 shadow-sm border border-gray-200 dark:border-gray-700 transition-all duration-300 hover:shadow-md">
                {{-- Accent strip borde izquierdo: 4px de ancho --}}
                <div style="position: absolute; left: 0; top: 0; height: 100%; width: 4px; border-radius: 0.75rem 0 0 0.75rem; background-color: {{ $rolMeta['hex'] }};"></div>
                {{-- Contenido con padding izquierdo generoso para no solaparse --}}
                <div style="padding: 1.25rem 1.25rem 1.25rem 1.25rem;">
                    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 0.5rem;">
                        <p style="font-size: 0.7rem; font-weight: 600; color: #6b7280; text-transform: uppercase; letter-spacing: 0.08em; padding-left: 0.5rem;">{{ $label }}</p>
                        <div style="height: 2rem; width: 2rem; border-radius: 0.5rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; background-color: {{ $rolMeta['hex'] }}22;">
                            <svg style="height: 1rem; width: 1rem; color: {{ $rolMeta['hex'] }};" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/></svg>
                        </div>
                    </div>
                    <p style="font-size: 1.875rem; font-weight: 900; color: #111827; letter-spacing: -0.025em; padding-left: 0.5rem;">{{ $valor }}</p>
                </div>
            </div>
            @endforeach
        </div>
    </div>
    @endif

    {{-- ═══════════════════════════════════════════════════════
         SECCIÓN 3 — PROPIEDADES DEL ROL EN POSTGRESQL
    ═══════════════════════════════════════════════════════ --}}
    @if($rolInfo)
    <div class="mt-6">
        <h2 class="text-lg font-bold text-gray-800 dark:text-gray-100 mb-4 flex items-center gap-2">
            <svg class="h-5 w-5" style="color: {{ $rolMeta['hex'] }};" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4"/></svg>
            Propiedades del rol en PostgreSQL
        </h2>
        <div class="overflow-hidden rounded-xl bg-white dark:bg-gray-800 shadow-md border border-gray-200 dark:border-gray-700">
            <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-px bg-gray-200 dark:bg-gray-700">
                @php
                    $propiedades = [
                        ['label' => 'Nombre del Rol',       'valor' => $rolInfo->rolname,         'tipo' => 'text'],
                        ['label' => 'Puede iniciar sesión', 'valor' => $rolInfo->rolcanlogin,     'tipo' => 'bool'],
                        ['label' => 'Hereda privilegios',   'valor' => $rolInfo->rolinherit,      'tipo' => 'bool'],
                        ['label' => 'Superusuario',         'valor' => $rolInfo->rolsuper,        'tipo' => 'bool'],
                        ['label' => 'Puede crear BD',       'valor' => $rolInfo->rolcreatedb,     'tipo' => 'bool'],
                        ['label' => 'Puede crear roles',    'valor' => $rolInfo->rolcreaterole,   'tipo' => 'bool'],
                        ['label' => 'Bypass RLS',           'valor' => $rolInfo->rolbypassrls,    'tipo' => 'bool'],
                        ['label' => 'Válido hasta',         'valor' => $rolInfo->rolvaliduntil ?? 'Sin expiración', 'tipo' => 'text'],
                    ];
                @endphp

                @foreach($propiedades as $prop)
                <div class="bg-white dark:bg-gray-800 p-4">
                    <p class="text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">{{ $prop['label'] }}</p>
                    @if($prop['tipo'] === 'bool')
                        @if($prop['valor'])
                            <span class="mt-1 inline-flex items-center gap-1 text-sm font-semibold text-emerald-600 dark:text-emerald-400">
                                <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
                                Sí
                            </span>
                        @else
                            <span class="mt-1 inline-flex items-center gap-1 text-sm font-semibold text-red-500 dark:text-red-400">
                                <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/></svg>
                                No
                            </span>
                        @endif
                    @else
                        <p class="mt-1 text-sm font-semibold text-gray-900 dark:text-white font-mono">{{ $prop['valor'] }}</p>
                    @endif
                </div>
                @endforeach
            </div>
        </div>
    </div>
    @endif

    {{-- ═══════════════════════════════════════════════════════
         SECCIÓN 4 — PERMISOS POR ESQUEMA (Dinámico desde PG)
    ═══════════════════════════════════════════════════════ --}}
    @if(count($permisosPorEsquema) > 0)
    <div class="mt-6">
        <h2 class="text-lg font-bold text-gray-800 dark:text-gray-100 mb-4 flex items-center gap-2">
            <svg class="h-5 w-5" style="color: {{ $rolMeta['hex'] }};" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/></svg>
            Permisos en tablas por esquema
            <span class="text-xs font-normal text-gray-400">(consultado en tiempo real desde information_schema)</span>
        </h2>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
            @foreach($permisosPorEsquema as $esquema => $tablas)
            <div class="rounded-xl bg-white dark:bg-gray-800 shadow-md border border-gray-200 dark:border-gray-700 overflow-hidden">
                {{-- Encabezado del esquema --}}
                <div class="px-5 py-3 border-b border-gray-200 dark:border-gray-700" style="background: linear-gradient(90deg, {{ $rolMeta['hex'] }}15, transparent);">
                    <h3 class="text-sm font-bold uppercase tracking-wider flex items-center gap-2" style="color: {{ $rolMeta['hex'] }};">
                        <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/></svg>
                        {{ $esquema }}
                        <span class="ml-auto text-xs font-normal text-gray-400">{{ count($tablas) }} tabla(s)</span>
                    </h3>
                </div>

                {{-- Tabla de permisos --}}
                <div class="divide-y divide-gray-100 dark:divide-gray-700/50">
                    @foreach($tablas as $tabla)
                    <div class="px-5 py-3 flex flex-col sm:flex-row sm:items-center justify-between gap-2 hover:bg-gray-50 dark:hover:bg-gray-700/30 transition-colors">
                        <span class="text-sm font-medium text-gray-800 dark:text-gray-200 font-mono">
                            {{ $tabla['tabla'] }}
                        </span>
                        <div class="flex flex-wrap gap-1">
                            @foreach(explode(', ', $tabla['privilegios']) as $priv)
                                @php
                                    $privStyle = match($priv) {
                                        'SELECT'  => 'background-color: #d1fae5; color: #047857;',
                                        'INSERT'  => 'background-color: #dbeafe; color: #1d4ed8;',
                                        'UPDATE'  => 'background-color: #fef3c7; color: #b45309;',
                                        'DELETE'  => 'background-color: #fee2e2; color: #b91c1c;',
                                        'TRIGGER' => 'background-color: #ede9fe; color: #6d28d9;',
                                        default   => 'background-color: #f3f4f6; color: #374151;',
                                    };
                                @endphp
                                <span class="inline-flex items-center rounded-md px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider" style="{{ $privStyle }}">
                                    {{ $priv }}
                                </span>
                            @endforeach
                        </div>
                    </div>
                    @endforeach
                </div>
            </div>
            @endforeach
        </div>
    </div>
    @endif

    {{-- ═══════════════════════════════════════════════════════
         SECCIÓN 5 — OTROS ADMINISTRADORES DEL SISTEMA
    ═══════════════════════════════════════════════════════ --}}
    @if($otrosAdmins->count() > 0)
    <div class="mt-6">
        <h2 class="text-lg font-bold text-gray-800 dark:text-gray-100 mb-4 flex items-center gap-2">
            <svg class="h-5 w-5" style="color: {{ $rolMeta['hex'] }};" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/></svg>
            Equipo de administración VIVA
        </h2>

        <div class="overflow-hidden rounded-xl bg-white dark:bg-gray-800 shadow-md border border-gray-200 dark:border-gray-700">
            <table class="w-full text-sm">
                <thead>
                    <tr class="bg-gray-50 dark:bg-gray-700/50">
                        <th class="px-5 py-3 text-left text-xs font-bold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Usuario</th>
                        <th class="px-5 py-3 text-left text-xs font-bold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Rol PostgreSQL</th>
                        <th class="px-5 py-3 text-left text-xs font-bold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Área</th>
                        <th class="px-5 py-3 text-center text-xs font-bold text-gray-500 dark:text-gray-400 uppercase tracking-wider">Estado</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100 dark:divide-gray-700/50">
                    @foreach($otrosAdmins as $admin)
                    @php
                        $meta = $rolesLegibles[$admin->rol_db] ?? ['nombre' => $admin->rol_db, 'icono' => '👤', 'hex' => '#6b7280', 'hexLight' => '#f3f4f6'];
                        $esYo = $admin->username === $username;
                    @endphp
                    <tr class="hover:bg-gray-50 dark:hover:bg-gray-700/30 transition-colors" @if($esYo) style="background-color: {{ $rolMeta['hexLight'] }}22;" @endif>
                        <td class="px-5 py-3">
                            <div class="flex items-center gap-3">
                                <span class="text-xl">{{ $meta['icono'] }}</span>
                                <div>
                                    <p class="font-semibold text-gray-900 dark:text-white">
                                        {{ $admin->username }}
                                        @if($esYo)
                                            <span class="ml-1 inline-flex items-center rounded-full px-2 py-0.5 text-[10px] font-bold" style="background-color: {{ $rolMeta['hexLight'] }}; color: {{ $rolMeta['hex'] }};">TÚ</span>
                                        @endif
                                    </p>
                                </div>
                            </div>
                        </td>
                        <td class="px-5 py-3 font-mono text-xs text-gray-600 dark:text-gray-400">{{ $admin->rol_db }}</td>
                        <td class="px-5 py-3 text-sm font-medium text-gray-700 dark:text-gray-300">{{ $meta['nombre'] }}</td>
                        <td class="px-5 py-3 text-center">
                            <span class="inline-flex items-center gap-1 rounded-full bg-emerald-100 dark:bg-emerald-900/40 px-2.5 py-1 text-xs font-semibold text-emerald-700 dark:text-emerald-400">
                                <span class="h-1.5 w-1.5 rounded-full bg-emerald-500"></span>
                                Activo
                            </span>
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    </div>
    @endif

    {{-- ═══════════════════════════════════════════════════════
         FOOTER — Nota de seguridad
    ═══════════════════════════════════════════════════════ --}}
    <div class="mt-6 rounded-xl bg-gray-50 dark:bg-gray-800/50 border border-gray-200 dark:border-gray-700 p-5">
        <div class="flex items-start gap-3">
            <svg class="h-5 w-5 text-gray-400 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
            <div>
                <p class="text-sm font-medium text-gray-700 dark:text-gray-300">
                    Principio de Mínimo Privilegio (Least Privilege)
                </p>
                <p class="mt-1 text-xs text-gray-500 dark:text-gray-400 leading-relaxed">
                    Todos los permisos mostrados se aplican a nivel de PostgreSQL mediante <code class="px-1 py-0.5 rounded bg-gray-200 dark:bg-gray-700 text-xs">GRANT</code> sobre el rol <code class="px-1 py-0.5 rounded bg-gray-200 dark:bg-gray-700 text-xs font-mono">{{ $rolDb }}</code>.
                    La conexión de la aplicación usa <code class="px-1 py-0.5 rounded bg-gray-200 dark:bg-gray-700 text-xs font-mono">SET ROLE</code> dinámico desde el middleware Laravel, asegurando que cada usuario opera únicamente con los privilegios asignados a su rol en la base de datos.
                </p>
            </div>
        </div>
    </div>
</x-filament-panels::page>
