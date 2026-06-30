<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ClienteResource\Pages;
use App\Models\Cliente;
use App\Models\PersonaNatural;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class ClienteResource extends Resource
{
    protected static ?string $model = Cliente::class;

    protected static ?string $navigationIcon = 'heroicon-o-users';
    
    protected static ?string $navigationLabel = 'Registro de Clientes';
    protected static ?string $pluralModelLabel = 'Clientes';
    protected static ?string $modelLabel = 'Cliente';

    public static function canAccess(): bool
    {
        return auth()->user()?->rol_db === 'rol_agencia';
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make('Datos de Registro')
                    ->schema([
                        Forms\Components\Select::make('estado')
                            ->options([
                                'Activo' => 'Activo',
                                'Inactivo' => 'Inactivo',
                            ])
                            ->default('Activo')
                            ->required()
                            ->label('Estado del Cliente'),
                        
                        Forms\Components\Hidden::make('fecha_registro')
                            ->default(fn () => now()->toDateTimeString()),
                    ])->columns(1),

                Forms\Components\Section::make('Datos Personales (Persona Natural)')
                    ->relationship('personaNatural')
                    ->schema([
                        Forms\Components\TextInput::make('nombre')
                            ->required()
                            ->maxLength(100)
                            ->label('Nombre'),
                        
                        Forms\Components\TextInput::make('apellido')
                            ->required()
                            ->maxLength(100)
                            ->label('Apellido'),
                        
                        Forms\Components\TextInput::make('ci')
                            ->required()
                            ->maxLength(20)
                            ->label('Carnet de Identidad (CI)')
                            ->unique(table: config('database.default') . '.' . (new PersonaNatural())->getTable(), column: 'ci', ignoreRecord: true),
                        
                        Forms\Components\TextInput::make('correo')
                            ->email()
                            ->maxLength(100)
                            ->label('Correo Electrónico'),
                    ])->columns(2),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('id_cliente')
                    ->label('ID Cliente')
                    ->sortable()
                    ->searchable(),
                
                Tables\Columns\TextColumn::make('personaNatural.nombre')
                    ->label('Nombre')
                    ->sortable()
                    ->searchable(),
                
                Tables\Columns\TextColumn::make('personaNatural.apellido')
                    ->label('Apellido')
                    ->sortable()
                    ->searchable(),
                
                Tables\Columns\TextColumn::make('personaNatural.ci')
                    ->label('CI')
                    ->sortable()
                    ->searchable(),
                
                Tables\Columns\TextColumn::make('personaNatural.correo')
                    ->label('Correo')
                    ->sortable()
                    ->searchable(),
                
                Tables\Columns\TextColumn::make('fecha_registro')
                    ->label('Fecha Registro')
                    ->dateTime('d/m/Y H:i:s')
                    ->sortable(),
                
                Tables\Columns\TextColumn::make('estado')
                    ->label('Estado')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'Activo' => 'success',
                        'Inactivo' => 'danger',
                        default => 'gray',
                    })
                    ->sortable(),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('estado')
                    ->options([
                        'Activo' => 'Activo',
                        'Inactivo' => 'Inactivo',
                    ])
                    ->label('Filtrar por Estado'),
            ])
            ->actions([
                Tables\Actions\ViewAction::make(),
                Tables\Actions\EditAction::make(),
            ])
            ->bulkActions([
                // No bulk actions for safety
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
            'index' => Pages\ListClientes::route('/'),
            'create' => Pages\CreateCliente::route('/create'),
            'view' => Pages\ViewCliente::route('/{record}'),
            'edit' => Pages\EditCliente::route('/{record}/edit'),
        ];
    }
}
