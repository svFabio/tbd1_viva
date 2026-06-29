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

            @foreach($appsExentas as $app)
                @php 
                    $clave = strtolower(preg_replace('/[^a-zA-Z0-9]+/', '', $app)); 
                    $tipoBackend = 'APP_' . strtoupper(preg_replace('/[^a-zA-Z0-9]+/', '', $app)); 
                @endphp
                <div class="p-6 bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm text-center flex flex-col items-center justify-center">
                    <div style="width: 48px; height: 48px;" class="mb-2 text-primary-500">
                        <x-heroicon-o-device-phone-mobile />
                    </div>
                    <h3 class="font-bold text-lg">Usar {{ $app }}</h3>
                    <p class="text-sm text-gray-500 mb-4">Uso de datos (gratis si tienes paquete)</p>
                    
                    <div x-show="!activo.{{ $clave }}">
                        <x-filament::button color="success" x-on:click="iniciar('{{ $clave }}')">Abrir {{ $app }}</x-filament::button>
                    </div>
                    <div x-show="activo.{{ $clave }}" class="w-full">
                        <div class="text-4xl font-bold text-success-600 mb-2" x-text="(segundos.{{ $clave }} || 0) + ' s'"></div>
                        <div class="text-lg text-gray-500 mb-4" x-text="'Usando app...'"></div>
                        <x-filament::button color="danger" x-on:click="detener('{{ $clave }}', '{{ $tipoBackend }}')">Cerrar App</x-filament::button>
                    </div>
                </div>
            @endforeach

            <!-- Enviar SMS Clásico -->
            <div class="p-6 bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm text-center flex flex-col items-center justify-center md:col-span-2">
                <div style="width: 48px; height: 48px;" class="mb-2 text-warning-500">
                    <x-heroicon-o-chat-bubble-oval-left-ellipsis />
                </div>
                <h3 class="font-bold text-lg">Enviar SMS Clásico</h3>
                <p class="text-sm text-gray-500 mb-4">El costo de la vida real: 1 SMS = 160 letras. Costo por SMS = 0.20 Bs.</p>
                
                <div x-show="!activo.sms" class="w-full max-w-2xl mx-auto">
                    <textarea x-model="mensajeSms" class="w-full rounded-lg border-gray-300 dark:border-gray-700 dark:bg-gray-900 shadow-sm mb-2 text-black dark:text-white" rows="3" placeholder="Escribe un mensaje de texto aquí..."></textarea>
                    <div class="text-sm text-right text-gray-500 mb-4 font-bold">
                        <span x-text="mensajeSms.length"></span> caracteres = <span x-text="Math.ceil(mensajeSms.length / 160) || 1"></span> SMS
                    </div>
                    <x-filament::button color="warning" x-on:click="enviarSms()">Enviar SMS</x-filament::button>
                </div>
                <div x-show="activo.sms" class="w-full">
                    <div class="text-2xl text-warning-500 mb-4 font-bold">¡Mensaje Enviado con éxito!</div>
                    <x-filament::button color="gray" x-on:click="resetSms()">Enviar otro SMS</x-filament::button>
                </div>
            </div>

        </div>
    </div>

    <script>
        document.addEventListener('alpine:init', () => {
            Alpine.data('simuladorTrafico', () => ({
                activo: { navegar: false, llamar: false, whatsapp: false, tiktok: false, sms: false },
                segundos: { navegar: 0, llamar: 0, whatsapp: 0, tiktok: 0 },
                intervalos: { navegar: null, llamar: null, whatsapp: null, tiktok: null },
                mensajeSms: '',

                iniciar(clave) {
                    if (this.activo[clave] === undefined) {
                        this.activo[clave] = false;
                        this.segundos[clave] = 0;
                        this.intervalos[clave] = null;
                    }
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
                        this.$wire.procesarTrafico(tipoBackEnd, this.segundos[clave]);
                    }
                    this.segundos[clave] = 0;
                },

                enviarSms() {
                    if (this.mensajeSms.length === 0) return;
                    this.activo.sms = true;
                    this.$wire.procesarSms(this.mensajeSms.length);
                },

                resetSms() {
                    this.activo.sms = false;
                    this.mensajeSms = '';
                }
            }))
        })
    </script>
</x-filament-panels::page>
