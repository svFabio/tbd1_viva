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
        $rol = auth()->user()?->rol_db;
        return $rol === 'rol_comercial';
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('nombre_paquete')
                    ->label('Nombre del Paquete (Ej: Bolsa WOW 500MB)')
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
                Forms\Components\TextInput::make('megas')
                    ->label('Megas incluidos')
                    ->numeric()
                    ->default(0),
                Forms\Components\TextInput::make('minutos')
                    ->label('Minutos incluidos')
                    ->numeric()
                    ->default(0),
                Forms\Components\TextInput::make('sms')
                    ->label('SMS incluidos')
                    ->numeric()
                    ->default(0),
                
                Forms\Components\Repeater::make('appsExentas')
                    ->relationship()
                    ->schema([
                        Forms\Components\TextInput::make('nombre_app')
                            ->label('Nombre de la App (Ej: WhatsApp, TikTok)')
                            ->required()
                            ->maxLength(50),
                    ])
                    ->label('Aplicaciones Exentas (Ilimitadas)')
                    ->addActionLabel('Agregar App'),
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
                Tables\Columns\TextColumn::make('megas')->label('MB'),
                Tables\Columns\TextColumn::make('minutos')->label('Min'),
                Tables\Columns\TextColumn::make('appsExentas.nombre_app')
                    ->label('Apps Exentas')
                    ->badge()
                    ->color('success'),
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
