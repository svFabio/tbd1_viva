<?php

namespace App\Filament\Resources;

use App\Filament\Resources\PromocionResource\Pages;
use App\Models\Promocion;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Filament\Forms\Components\Repeater;

class PromocionResource extends Resource
{
    protected static ?string $model = Promocion::class;
    protected static ?string $navigationIcon = 'heroicon-o-megaphone';
    protected static ?string $navigationGroup = 'Comercial y Servicios';
    protected static ?string $navigationLabel = 'Promociones (Marketing)';
    protected static ?string $modelLabel = 'Promoción';
    protected static ?string $pluralModelLabel = 'Promociones';
    protected static ?int $navigationSort = 1;

    public static function canAccess(): bool
    {
        return auth()->user()?->rol_db === 'rol_comercial';
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make('Detalles de la Campaña')
                    ->description('Configura las fechas y reglas de negocio para la promoción')
                    ->schema([
                        Forms\Components\TextInput::make('nombre_promo')
                            ->label('Nombre de la Promoción')
                            ->required()
                            ->maxLength(100)
                            ->columnSpan('full'),
                            
                        Forms\Components\Textarea::make('descripcion')
                            ->label('Descripción Comercial')
                            ->maxLength(65535)
                            ->columnSpan('full'),
                            
                        Forms\Components\DateTimePicker::make('fecha_inicio')
                            ->label('Fecha de Inicio')
                            ->required(),
                            
                        Forms\Components\DateTimePicker::make('fecha_fin')
                            ->label('Fecha de Expiración')
                            ->required(),
                    ])->columns(2),

                Forms\Components\Section::make('Condiciones')
                    ->description('Lista de requisitos para que el cliente acceda al beneficio')
                    ->schema([
                        Repeater::make('condiciones')
                            ->relationship()
                            ->schema([
                                Forms\Components\TextInput::make('descripcion_condicion')
                                    ->label('Regla / Condición')
                                    ->required()
                                    ->maxLength(255),
                            ])
                            ->addActionLabel('Añadir Condición')
                            ->defaultItems(1)
                            ->columnSpan('full'),
                    ])
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('nombre_promo')
                    ->label('Promoción')
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),
                    
                Tables\Columns\TextColumn::make('fecha_inicio')
                    ->label('Inicia')
                    ->dateTime('d/m/Y H:i')
                    ->sortable(),
                    
                Tables\Columns\TextColumn::make('fecha_fin')
                    ->label('Termina')
                    ->dateTime('d/m/Y H:i')
                    ->sortable(),
                    
                Tables\Columns\TextColumn::make('estado')
                    ->label('Estado')
                    ->badge()
                    ->color(fn (Promocion $record): string => 
                        $record->fecha_fin > now() && $record->fecha_inicio <= now() ? 'success' : 'danger'
                    )
                    ->getStateUsing(fn (Promocion $record): string => 
                        $record->fecha_fin > now() && $record->fecha_inicio <= now() ? 'Vigente' : 'Inactiva'
                    ),
                    
                Tables\Columns\TextColumn::make('condiciones_count')
                    ->counts('condiciones')
                    ->label('Reglas')
                    ->badge(),
            ])
            ->filters([
                //
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
            ])
            ->bulkActions([
                // Eliminado el DeleteBulkAction
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
            'index' => Pages\ListPromocions::route('/'),
            'create' => Pages\CreatePromocion::route('/create'),
            'edit' => Pages\EditPromocion::route('/{record}/edit'),
        ];
    }
}
