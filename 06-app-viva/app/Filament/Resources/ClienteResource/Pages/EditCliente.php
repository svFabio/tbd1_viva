<?php

namespace App\Filament\Resources\ClienteResource\Pages;

use App\Filament\Resources\ClienteResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditCliente extends EditRecord
{
    protected static string $resource = ClienteResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\ViewAction::make(),
        ];
    }

    protected function afterSave(): void
    {
        $record = $this->record;
        $data = $this->form->getRawState();

        if (isset($data['tipo_cliente'])) {
            if ($data['tipo_cliente'] === 'Persona Natural') {
                $record->empresa()->delete();
            } else {
                $record->personaNatural()->delete();
            }
        }
    }
}
