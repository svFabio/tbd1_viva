<?php

namespace App\Filament\Resources\ClienteResource\RelationManagers;

use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Support\Facades\DB;

class LineasRelationManager extends RelationManager
{
    protected static string $relationship = 'lineas';

    protected static ?string $title = 'Líneas Telefónicas';

    public function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Select::make('estado')
                    ->options([
                        'Activo' => 'Activo',
                        'Inactivo' => 'Inactivo (Dar de baja)',
                    ])
                    ->required()
                    ->label('Estado de la Línea'),
            ]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->recordTitleAttribute('numero_telefono')
            ->columns([
                Tables\Columns\TextColumn::make('numero_telefono')
                    ->label('Número de Teléfono')
                    ->searchable()
                    ->sortable(),
                Tables\Columns\TextColumn::make('plan_nombre')
                    ->label('Plan')
                    ->state(fn ($record) => DB::table('lineas.Plan')->where('id_plan', $record->id_plan)->value('nombre_plan')),
                Tables\Columns\TextColumn::make('sim_iccid')
                    ->label('ICCID SIM')
                    ->state(fn ($record) => DB::table('lineas.SIM_Card')->where('id_sim', $record->id_sim_activo)->value('iccid')),
                Tables\Columns\TextColumn::make('estado')
                    ->label('Estado')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'Activo' => 'success',
                        'Inactivo' => 'danger',
                        default => 'gray',
                    }),
            ])
            ->filters([
                //
            ])
            ->headerActions([
                //
            ])
            ->actions([
                Tables\Actions\EditAction::make()
                    ->label('Editar Estado')
                    ->modalHeading('Editar Estado de la Línea')
                    ->successNotificationTitle('Estado de la línea actualizado'),
                
                Tables\Actions\Action::make('dar_de_baja')
                    ->label('Dar de Baja')
                    ->color('danger')
                    ->icon('heroicon-o-trash')
                    ->requiresConfirmation()
                    ->visible(fn ($record) => $record->estado === 'Activo')
                    ->action(function ($record) {
                        $record->update(['estado' => 'Inactivo']);
                        
                        \Filament\Notifications\Notification::make()
                            ->title('Línea dada de baja')
                            ->body("La línea {$record->numero_telefono} ha sido dada de baja exitosamente.")
                            ->success()
                            ->send();
                    })
            ])
            ->bulkActions([
                //
            ]);
    }
}
