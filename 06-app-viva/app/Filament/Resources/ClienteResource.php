<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ClienteResource\Pages;
use App\Filament\Resources\ClienteResource\RelationManagers;
use App\Models\Cliente;
use App\Models\PersonaNatural;
use App\Models\Empresa;
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
                        Forms\Components\Select::make('tipo_cliente')
                            ->label('Tipo de Cliente')
                            ->options([
                                'Persona Natural' => 'Persona Natural',
                                'Empresa' => 'Empresa',
                            ])
                            ->default('Persona Natural')
                            ->required()
                            ->live()
                            ->afterStateHydrated(function ($set, $record) {
                                if ($record) {
                                    if ($record->empresa()->exists()) {
                                        $set('tipo_cliente', 'Empresa');
                                    } else {
                                        $set('tipo_cliente', 'Persona Natural');
                                    }
                                }
                            })
                            ->dehydrated(false),

                        Forms\Components\Select::make('estado')
                            ->options([
                                'Activo' => 'Activo',
                                'Inactivo' => 'Inactivo',
                            ])
                            ->default('Activo')
                            ->required()
                            ->label('Estado del Cliente'),
                            
                        Forms\Components\Select::make('ciudad')
                            ->options([
                                'La Paz' => 'La Paz',
                                'Cochabamba' => 'Cochabamba',
                                'Santa Cruz' => 'Santa Cruz',
                                'Oruro' => 'Oruro',
                                'Tarija' => 'Tarija',
                                'Potosí' => 'Potosí',
                                'Chuquisaca' => 'Chuquisaca',
                                'Beni' => 'Beni',
                                'Pando' => 'Pando',
                            ])
                            ->required()
                            ->label('Ciudad'),
                        
                        Forms\Components\Hidden::make('fecha_registro')
                            ->default(fn () => now()->toDateTimeString()),
                    ])->columns(2),

                Forms\Components\Section::make('Datos Personales (Persona Natural)')
                    ->relationship('personaNatural')
                    ->visible(fn ($get) => $get('tipo_cliente') === 'Persona Natural')
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

                Forms\Components\Section::make('Datos de la Empresa')
                    ->relationship('empresa')
                    ->visible(fn ($get) => $get('tipo_cliente') === 'Empresa')
                    ->schema([
                        Forms\Components\TextInput::make('razon_social')
                            ->required()
                            ->maxLength(150)
                            ->label('Razón Social'),
                        
                        Forms\Components\TextInput::make('nit')
                            ->required()
                            ->maxLength(20)
                            ->label('NIT')
                            ->unique(table: config('database.default') . '.' . (new Empresa())->getTable(), column: 'nit', ignoreRecord: true),
                        
                        Forms\Components\TextInput::make('representante_legal')
                            ->maxLength(100)
                            ->label('Representante Legal'),
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
                
                Tables\Columns\TextColumn::make('tipo')
                    ->label('Tipo')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'Empresa' => 'info',
                        'Persona Natural' => 'warning',
                        default => 'gray',
                    })
                    ->state(fn ($record) => $record->empresa()->exists() ? 'Empresa' : 'Persona Natural'),

                Tables\Columns\TextColumn::make('nombre_cliente')
                    ->label('Nombre / Razón Social')
                    ->state(fn ($record) => $record->empresa 
                        ? $record->empresa->razon_social 
                        : ($record->personaNatural ? "{$record->personaNatural->nombre} {$record->personaNatural->apellido}" : '-'))
                    ->searchable(query: function ($query, string $search) {
                        $query->whereHas('personaNatural', function ($q) use ($search) {
                            $q->where('nombre', 'ilike', "%{$search}%")
                              ->orWhere('apellido', 'ilike', "%{$search}%");
                        })->orWhereHas('empresa', function ($q) use ($search) {
                            $q->where('razon_social', 'ilike', "%{$search}%");
                        })->orWhereHas('lineas', function ($q) use ($search) {
                            $q->where('numero_telefono', 'ilike', "%{$search}%");
                        });
                    }),

                Tables\Columns\TextColumn::make('numeros_linea')
                    ->label('Número(s) de Línea')
                    ->state(function ($record) {
                        $numeros = $record->lineas()->pluck('numero_telefono')->toArray();
                        return count($numeros) ? implode(', ', $numeros) : '-';
                    })
                    ->searchable(query: function ($query, string $search) {
                        $query->whereHas('lineas', function ($q) use ($search) {
                            $q->where('numero_telefono', 'ilike', "%{$search}%");
                        });
                    }),

                Tables\Columns\TextColumn::make('documento')
                    ->label('Documento (CI / NIT)')
                    ->state(fn ($record) => $record->empresa 
                        ? "NIT: {$record->empresa->nit}" 
                        : ($record->personaNatural ? "CI: {$record->personaNatural->ci}" : '-'))
                    ->searchable(query: function ($query, string $search) {
                        $query->whereHas('personaNatural', function ($q) use ($search) {
                            $q->where('ci', 'like', "%{$search}%");
                        })->orWhereHas('empresa', function ($q) use ($search) {
                            $q->where('nit', 'like', "%{$search}%");
                        });
                    }),
                    
                Tables\Columns\TextColumn::make('ciudad')
                    ->label('Ciudad')
                    ->searchable()
                    ->sortable(),

                Tables\Columns\TextColumn::make('contacto')
                    ->label('Contacto / Correo')
                    ->state(fn ($record) => $record->empresa 
                        ? "Rep: {$record->empresa->representante_legal}" 
                        : ($record->personaNatural ? $record->personaNatural->correo : '-')),

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
                    
                Tables\Filters\SelectFilter::make('ciudad')
                    ->options([
                        'La Paz' => 'La Paz',
                        'Cochabamba' => 'Cochabamba',
                        'Santa Cruz' => 'Santa Cruz',
                        'Oruro' => 'Oruro',
                        'Tarija' => 'Tarija',
                        'Potosí' => 'Potosí',
                        'Chuquisaca' => 'Chuquisaca',
                        'Beni' => 'Beni',
                        'Pando' => 'Pando',
                    ])
                    ->label('Filtrar por Ciudad'),
            ])
            ->actions([
                Tables\Actions\ViewAction::make(),
            ])
            ->bulkActions([
                // No bulk actions for safety
            ]);
    }

    public static function getRelations(): array
    {
        return [
            RelationManagers\LineasRelationManager::class,
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
