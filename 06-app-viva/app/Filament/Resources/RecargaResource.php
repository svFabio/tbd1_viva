<?php

namespace App\Filament\Resources;

use App\Filament\Resources\RecargaResource\Pages;
use App\Models\Recarga;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class RecargaResource extends Resource
{
    protected static ?string $model = Recarga::class;

    protected static ?string $navigationIcon = 'heroicon-o-banknotes';
    
    protected static ?string $navigationGroup = 'Finanzas y Recaudación';
    protected static ?string $navigationLabel = 'Historial de Recargas';

    public static function canAccess(): bool
    {
        $rol = auth()->user()?->rol_db;
        return $rol === 'rol_finanzas';
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make('Detalles de la Recarga')
                    ->schema([
                        Forms\Components\TextInput::make('id_linea')
                            ->required()
                            ->numeric()
                            ->label('ID de Línea Destino'),
                        Forms\Components\TextInput::make('monto')
                            ->required()
                            ->numeric()
                            ->prefix('Bs.')
                            ->label('Monto Recargado'),
                    ])->columns(2),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('id_recarga')
                    ->label('Nº Transacción')
                    ->sortable()
                    ->searchable(),
                Tables\Columns\TextColumn::make('id_linea')
                    ->label('Línea Beneficiaria')
                    ->numeric()
                    ->sortable()
                    ->searchable(),
                Tables\Columns\TextColumn::make('monto')
                    ->label('Monto (Bs)')
                    ->money('BOB')
                    ->sortable()
                    ->color('success')
                    ->weight('bold'),
                Tables\Columns\TextColumn::make('metodo_pago')
                    ->label('Medio de Pago')
                    ->badge()
                    ->searchable(),
                Tables\Columns\TextColumn::make('fecha_recarga')
                    ->label('Fecha')
                    ->dateTime('d/m/Y H:i:s')
                    ->sortable(),
            ])
            ->defaultSort('fecha_recarga', 'desc')
            ->filters([
                //
            ])
            ->actions([
                Tables\Actions\ViewAction::make(),
            ])
            ->bulkActions([
            ]);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListRecargas::route('/'),
        ];
    }
}
