<?php

namespace App\Filament\Resources;

use App\Filament\Resources\FacturaResource\Pages;
use App\Models\Factura;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class FacturaResource extends Resource
{
    protected static ?string $model = Factura::class;

    protected static ?string $navigationIcon = 'heroicon-o-document-currency-dollar';
    
    protected static ?string $navigationGroup = 'Finanzas y Recaudación';
    protected static ?string $navigationLabel = 'Gestión de Facturas';

    public static function canAccess(): bool
    {
        $user = auth()->user();
        return $user && in_array($user->username, ['u.finanzas', 'u.reporte', 'u.auditor']);
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make('Detalles de Facturación')
                    ->description('Información financiera de la cuenta')
                    ->schema([
                        Forms\Components\TextInput::make('id_linea')
                            ->required()
                            ->numeric()
                            ->label('ID de Línea'),
                        Forms\Components\DateTimePicker::make('fecha_emision')
                            ->required()
                            ->label('Fecha de Emisión'),
                        Forms\Components\TextInput::make('monto_total')
                            ->required()
                            ->numeric()
                            ->prefix('Bs.')
                            ->label('Monto Total'),
                        Forms\Components\Select::make('estado_pago')
                            ->required()
                            ->options([
                                'Pendiente' => 'Pendiente',
                                'Pagado' => 'Pagado',
                                'Vencido' => 'Vencido',
                            ])
                            ->label('Estado de Pago'),
                    ])->columns(2),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('id_factura')
                    ->label('Nº Factura')
                    ->sortable()
                    ->searchable(),
                Tables\Columns\TextColumn::make('id_linea')
                    ->label('Línea Asignada')
                    ->numeric()
                    ->sortable()
                    ->searchable(),
                Tables\Columns\TextColumn::make('monto_total')
                    ->label('Total (Bs)')
                    ->money('BOB')
                    ->sortable(),
                Tables\Columns\TextColumn::make('estado_pago')
                    ->label('Estado')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'Pagado' => 'success',
                        'Pendiente' => 'warning',
                        'Vencido' => 'danger',
                        default => 'gray',
                    })
                    ->searchable(),
                Tables\Columns\TextColumn::make('fecha_emision')
                    ->label('Fecha Emisión')
                    ->dateTime('d/m/Y H:i')
                    ->sortable(),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('estado_pago')
                    ->options([
                        'Pagado' => 'Pagado',
                        'Pendiente' => 'Pendiente',
                        'Vencido' => 'Vencido',
                    ])
                    ->label('Filtrar por Estado'),
            ])
            ->actions([
                Tables\Actions\ViewAction::make(),
                Tables\Actions\EditAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    // Only allow export or something, avoid delete for finanzas usually
                ]),
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
            'index' => Pages\ListFacturas::route('/'),
            'create' => Pages\CreateFactura::route('/create'),
            'view' => Pages\ViewFactura::route('/{record}'),
            'edit' => Pages\EditFactura::route('/{record}/edit'),
        ];
    }
}
