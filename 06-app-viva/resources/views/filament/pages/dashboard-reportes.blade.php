<x-filament-panels::page>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
        <!-- Tarjeta 1 -->
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow p-6 border border-gray-200 dark:border-gray-700">
            <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400">Total Clientes Registrados</h3>
            <p class="text-3xl font-bold text-primary-600 dark:text-primary-400 mt-2">
                {{ number_format($totalClientes) }}
            </p>
            <p class="text-xs text-gray-400 mt-2">Esquema: clientes.Cliente</p>
        </div>

        <!-- Tarjeta 2 -->
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow p-6 border border-gray-200 dark:border-gray-700">
            <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400">Líneas Móviles Activas</h3>
            <p class="text-3xl font-bold text-success-600 dark:text-success-400 mt-2">
                {{ number_format($totalLineasActivas) }}
            </p>
            <p class="text-xs text-gray-400 mt-2">Esquema: lineas.Linea</p>
        </div>

        <!-- Tarjeta 3 -->
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow p-6 border border-gray-200 dark:border-gray-700">
            <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400">Ingresos Totales (Recaudación)</h3>
            <p class="text-3xl font-bold text-warning-600 dark:text-warning-400 mt-2">
                Bs. {{ number_format($ingresosTotales, 2) }}
            </p>
            <p class="text-xs text-gray-400 mt-2">Esquema: finanzas.Factura</p>
        </div>
    </div>

    <div class="bg-white dark:bg-gray-800 rounded-xl shadow p-6 border border-gray-200 dark:border-gray-700">
        <h2 class="text-lg font-bold mb-4">Privilegios de BI (Business Intelligence)</h2>
        <p class="text-sm text-gray-600 dark:text-gray-300">
            Como usuario con el rol <strong>u.reporte</strong>, tienes el permiso único de hacer cruces multidimensionales (JOINs) a través de todos los esquemas de la arquitectura (Clientes, Líneas, Finanzas, Servicios, etc.) para extraer valor, generar inteligencia de negocios y alimentar modelos predictivos de datos masivos. 
        </p>
        <p class="text-sm text-gray-600 dark:text-gray-300 mt-2">
            La base de datos bloquea completamente a este rol cualquier intento de UPDATE, DELETE o INSERT por seguridad (Solo Lectura Analítica).
        </p>
    </div>
</x-filament-panels::page>
