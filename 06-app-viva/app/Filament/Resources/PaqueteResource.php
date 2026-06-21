<?php

namespace App\Filament\Resources;

use App\Models\Paquete;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class PaqueteResource extends Resource
{
    protected static ?string $model = Paquete::class;

    protected static ?string $navigationIcon = 'heroicon-o-cube';
    protected static ?string $navigationLabel = 'Gestión de Paquetes';
    protected static ?string $pluralModelLabel = 'Paquetes';

    public static function canAccess(): bool
    {
        return auth()->user()->id_cliente === null;
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('nombre_paquete')
                    ->label('Nombre del Paquete (Ej: Bolsa 500MB)')
                    ->required()
                    ->maxLength(50),
                Forms\Components\TextInput::make('costo')
                    ->label('Costo (Bs.)')
                    ->required()
                    ->numeric(),
                Forms\Components\TextInput::make('duracion_dias')
                    ->label('Duración en Días')
                    ->required()
                    ->numeric(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('id_paquete')->sortable(),
                Tables\Columns\TextColumn::make('nombre_paquete')->searchable(),
                Tables\Columns\TextColumn::make('costo')->money('BOB')->sortable(),
                Tables\Columns\TextColumn::make('duracion_dias')->sortable(),
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ]);
    }

    public static function getPages(): array
    {
        return [
            'index' => \App\Filament\Resources\PaqueteResource\Pages\ManagePaquetes::route('/'),
        ];
    }
}
