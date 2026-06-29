<?php

namespace App\Filament\Resources;

use App\Models\Paquete;
use App\Models\AppExentaEnBolsa;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Support\Facades\DB;

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
                        Forms\Components\Select::make('nombre_app')
                            ->label('Aplicación Exenta')
                            ->required()
                            ->searchable()
                            ->getSearchResultsUsing(function (string $search) {
                                // Solo muestra apps ya registradas en la BD — no se pueden inventar nuevas
                                return AppExentaEnBolsa::select('nombre_app')
                                    ->where('nombre_app', 'ilike', "%{$search}%")
                                    ->distinct()
                                    ->orderBy('nombre_app')
                                    ->limit(20)
                                    ->pluck('nombre_app', 'nombre_app')
                                    ->toArray();
                            })
                            ->getOptionLabelUsing(fn ($value) => $value)
                            ->placeholder('Busca una app del catálogo...'),
                    ])
                    ->label('Aplicaciones Exentas (Ilimitadas)')
                    ->addActionLabel('Agregar App')
                    ->distinct(),  // Evita que se repita la misma app en el mismo paquete
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
                Tables\Columns\IconColumn::make('activo')
                    ->label('Estado')
                    ->boolean()
                    ->trueIcon('heroicon-o-check-circle')
                    ->falseIcon('heroicon-o-x-circle')
                    ->trueColor('success')
                    ->falseColor('danger'),
            ])
            ->modifyQueryUsing(fn ($query) => $query->withoutGlobalScope('activo')) // Mostrar todos para gestión
            ->actions([
                Tables\Actions\EditAction::make(),
                Tables\Actions\Action::make('desactivar')
                    ->label('Desactivar')
                    ->icon('heroicon-o-eye-slash')
                    ->color('danger')
                    ->requiresConfirmation()
                    ->modalHeading('¿Desactivar este paquete?')
                    ->modalDescription('El paquete dejará de estar disponible para nuevos clientes. Los clientes que ya lo tienen activo no se ven afectados. Esta acción es reversible.')
                    ->visible(fn ($record) => $record->activo)
                    ->action(fn ($record) => $record->desactivar()),
                Tables\Actions\Action::make('activar')
                    ->label('Reactivar')
                    ->icon('heroicon-o-eye')
                    ->color('success')
                    ->requiresConfirmation()
                    ->modalHeading('¿Reactivar este paquete?')
                    ->modalDescription('El paquete volverá a estar disponible para la venta.')
                    ->visible(fn ($record) => !$record->activo)
                    ->action(fn ($record) => $record->activar()),
            ])
            ->bulkActions([]); // Sin borrado masivo
    }

    public static function getPages(): array
    {
        return [
            'index' => \App\Filament\Resources\PaqueteResource\Pages\ManagePaquetes::route('/'),
        ];
    }
}
