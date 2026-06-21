<x-filament-panels::page>
    <div class="mb-4 space-y-4">
        <h2 class="text-xl font-bold">Generador de Tráfico (Pruebas)</h2>
        <p class="text-gray-500">
            Simula el uso en tiempo real de tu celular. Observa cómo corre el contador de segundos y megas.
        </p>

        <div x-data="simuladorTrafico()" class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-6">
            
            <!-- Navegación -->
            <div class="p-6 bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm text-center flex flex-col items-center justify-center">
                <div style="width: 48px; height: 48px;" class="mb-2 text-primary-500">
                    <x-heroicon-o-globe-alt />
                </div>
                <h3 class="font-bold text-lg">Navegar por Internet</h3>
                <p class="text-sm text-gray-500 mb-4">Gasta 1 MB por segundo</p>
                
                <div x-show="!activo.navegar">
                    <x-filament::button x-on:click="iniciar('navegar')">Iniciar Navegación</x-filament::button>
                </div>
                <div x-show="activo.navegar" class="w-full">
                    <div class="text-4xl font-bold text-primary-600 mb-2" x-text="segundos.navegar + ' s'"></div>
                    <div class="text-lg text-red-500 mb-4" x-text="'-' + segundos.navegar + ' MB'"></div>
                    <x-filament::button color="danger" x-on:click="detener('navegar', 'DATOS_GENERAL')">Detener y Cobrar</x-filament::button>
                </div>
            </div>

            <!-- Llamadas -->
            <div class="p-6 bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm text-center flex flex-col items-center justify-center">
                <div style="width: 48px; height: 48px;" class="mb-2 text-success-500">
                    <x-heroicon-o-phone />
                </div>
                <h3 class="font-bold text-lg">Llamada de Voz</h3>
                <p class="text-sm text-gray-500 mb-4">Simulador: 1 Minuto gastado por segundo real</p>
                
                <div x-show="!activo.llamar">
                    <x-filament::button color="success" x-on:click="iniciar('llamar')">Llamar a Mamá</x-filament::button>
                </div>
                <div x-show="activo.llamar" class="w-full">
                    <div class="text-4xl font-bold text-success-600 mb-2" x-text="segundos.llamar + ' s'"></div>
                    <div class="text-lg text-red-500 mb-4" x-text="'-' + segundos.llamar + ' Min'"></div>
                    <x-filament::button color="danger" x-on:click="detener('llamar', 'VOZ')">Colgar</x-filament::button>
                </div>
            </div>

            <!-- WhatsApp -->
            <div class="p-6 bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm text-center flex flex-col items-center justify-center">
                <div style="width: 48px; height: 48px;" class="mb-2 text-green-500">
                    <x-heroicon-o-chat-bubble-left-right />
                </div>
                <h3 class="font-bold text-lg">Mandar WhatsApp</h3>
                <p class="text-sm text-gray-500 mb-4">Gasta 0.1 MB por segundo (¡A menos que tengas ilimitado!)</p>
                
                <div x-show="!activo.whatsapp">
                    <x-filament::button color="success" x-on:click="iniciar('whatsapp')">Abrir WhatsApp</x-filament::button>
                </div>
                <div x-show="activo.whatsapp" class="w-full">
                    <div class="text-4xl font-bold text-green-600 mb-2" x-text="segundos.whatsapp + ' s'"></div>
                    <div class="text-lg text-gray-500 mb-4" x-text="'Enviando mensajes...'"></div>
                    <x-filament::button color="danger" x-on:click="detener('whatsapp', 'APP_WHATSAPP')">Cerrar App</x-filament::button>
                </div>
            </div>

            <!-- TikTok -->
            <div class="p-6 bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm text-center flex flex-col items-center justify-center">
                <div style="width: 48px; height: 48px;" class="mb-2 text-gray-900 dark:text-white">
                    <x-heroicon-o-video-camera />
                </div>
                <h3 class="font-bold text-lg">Ver TikTok</h3>
                <p class="text-sm text-gray-500 mb-4">Gasta 1 MB por segundo (¡Muy pesado!)</p>
                
                <div x-show="!activo.tiktok">
                    <x-filament::button color="gray" x-on:click="iniciar('tiktok')">Ver Videos</x-filament::button>
                </div>
                <div x-show="activo.tiktok" class="w-full">
                    <div class="text-4xl font-bold text-gray-900 dark:text-white mb-2" x-text="segundos.tiktok + ' s'"></div>
                    <div class="text-lg text-gray-500 mb-4" x-text="'Deslizando videos...'"></div>
                    <x-filament::button color="danger" x-on:click="detener('tiktok', 'APP_TIKTOK')">Cerrar App</x-filament::button>
                </div>
            </div>

        </div>
    </div>

    <script>
        document.addEventListener('alpine:init', () => {
            Alpine.data('simuladorTrafico', () => ({
                activo: { navegar: false, llamar: false, whatsapp: false, tiktok: false },
                segundos: { navegar: 0, llamar: 0, whatsapp: 0, tiktok: 0 },
                intervalos: { navegar: null, llamar: null, whatsapp: null, tiktok: null },

                iniciar(clave) {
                    this.activo[clave] = true;
                    this.segundos[clave] = 0;
                    this.intervalos[clave] = setInterval(() => {
                        this.segundos[clave]++;
                    }, 1000);
                },

                detener(clave, tipoBackEnd) {
                    this.activo[clave] = false;
                    clearInterval(this.intervalos[clave]);
                    
                    if(this.segundos[clave] > 0) {
                        // Llamar a la función de PHP en el backend usando this.$wire
                        this.$wire.procesarTrafico(tipoBackEnd, this.segundos[clave]);
                    }
                    this.segundos[clave] = 0;
                }
            }))
        })
    </script>
</x-filament-panels::page>
