<?php

namespace App\Filament\Resources;

use App\Filament\Resources\AuditoriaResource\Pages;
use App\Models\Auditoria;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;

class AuditoriaResource extends Resource
{
    protected static ?string $model = Auditoria::class;

    protected static ?string $navigationIcon = 'heroicon-o-shield-check';
    
    protected static ?string $navigationGroup = 'Seguridad y Auditoría';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                // El auditor solo debe ver, no editar
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('id_auditoria')
                    ->label('ID')
                    ->sortable()
                    ->searchable(),
                Tables\Columns\TextColumn::make('fecha')
                    ->label('Fecha y Hora')
                    ->dateTime('d/m/Y H:i:s')
                    ->sortable(),
                Tables\Columns\TextColumn::make('usuario_db')
                    ->label('Usuario de Red')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'u_adan_pereira', 'u_aurelio_casillas' => 'danger',
                        'admin.promo', 'u.auditor' => 'success',
                        default => 'warning',
                    })
                    ->searchable(),
                Tables\Columns\TextColumn::make('tabla_afectada')
                    ->label('Tabla Afectada')
                    ->searchable()
                    ->sortable(),
                Tables\Columns\TextColumn::make('operacion')
                    ->label('Operación')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'INSERT' => 'success',
                        'UPDATE' => 'warning',
                        'DELETE' => 'danger',
                        default => 'primary',
                    })
                    ->searchable(),
                Tables\Columns\TextColumn::make('detalle_cambio')
                    ->label('Detalles JSON')
                    ->limit(50)
                    ->searchable(),
            ])
            ->defaultSort('fecha', 'desc')
            ->filters([
                //
            ])
            ->actions([
                // Solo View, sin Edit ni Delete
                Tables\Actions\ViewAction::make(),
            ])
            ->bulkActions([
                // Sin Bulk Actions
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
            'index' => Pages\ListAuditorias::route('/'),
            'view' => Pages\ViewAuditoria::route('/{record}'),
        ];
    }
}
