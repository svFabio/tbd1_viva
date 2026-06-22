<?php

namespace App\Filament\Resources\RecargaResource\Pages;

use App\Filament\Resources\RecargaResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListRecargas extends ListRecords
{
    protected static string $resource = RecargaResource::class;

    protected function getHeaderActions(): array
    {
        return [
            //
        ];
    }
}
