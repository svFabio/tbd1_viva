<x-filament-panels::page>
    <div class="max-w-xl mx-auto w-full">
        <x-filament::section>
            <x-slot name="heading">
                Saldo a tu medida
            </x-slot>
            <x-slot name="description">
                Ingresa el monto que deseas recargar a tu línea actual. 
                Si hoy es día de Doble Carga, ¡el monto se duplicará automáticamente en tu bolsillo!
            </x-slot>

            <form wire:submit="submit">
                {{ $this->form }}

                <div class="mt-6 flex justify-end">
                    <x-filament::button type="submit" color="primary" size="lg" icon="heroicon-o-credit-card">
                        Procesar Recarga
                    </x-filament::button>
                </div>
            </form>
        </x-filament::section>
    </div>
</x-filament-panels::page>
