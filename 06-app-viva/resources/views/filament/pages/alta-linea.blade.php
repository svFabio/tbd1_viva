<x-filament-panels::page>
    <x-filament-panels::form wire:submit="create">
        {{ $this->form }}

        <x-filament-panels::form.actions
            :actions="[
                \Filament\Actions\Action::make('create')
                    ->label('Completar Alta de Línea')
                    ->submit('create')
                    ->color('primary')
                    ->icon('heroicon-o-check-circle'),
            ]"
        />
    </x-filament-panels::form>
</x-filament-panels::page>
