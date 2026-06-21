<?php

namespace App\Filament\Pages;

use Filament\Pages\Page;
use Filament\Tables\Contracts\HasTable;
use Filament\Tables\Concerns\InteractsWithTable;
use Filament\Tables\Table;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Actions\Action;
use Filament\Notifications\Notification;
use App\Models\Paquete;
use App\Models\Bolsillo;
use App\Models\Linea;
use App\Models\BolsaActiva;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

class TiendaPaquetes extends Page implements HasTable
{
    use InteractsWithTable;

    protected static ?string $navigationIcon = 'heroicon-o-shopping-bag';
    protected static ?string $navigationLabel = 'Tienda VIVA';
    protected static ?string $title = 'Comprar Paquetes';
    protected static ?int $navigationSort = 2;

    protected static string $view = 'filament.pages.tienda-paquetes';

    public static function canAccess(): bool
    {
        return auth()->user()->id_cliente !== null;
    }

    public function table(Table $table): Table
    {
        return $table
            ->query(Paquete::query())
            ->columns([
                TextColumn::make('nombre_paquete')
                    ->label('Paquete')
                    ->searchable()
                    ->weight('bold')
                    ->color('primary'),
                
                TextColumn::make('costo')
                    ->label('Precio (Bs.)')
                    ->money('BOB')
                    ->sortable()
                    ->color('success'),

                TextColumn::make('duracion_dias')
                    ->label('Duración (Días)')
                    ->numeric()
                    ->sortable(),

                TextColumn::make('beneficios')
                    ->label('Incluye')
                    ->getStateUsing(function (Paquete $record) {
                        $b = [];
                        if ($record->megas > 0) {
                            $b[] = ($record->megas >= 1024) ? ($record->megas/1024).' GB' : $record->megas.' MB';
                        }
                        if ($record->minutos > 0) $b[] = $record->minutos.' Min';
                        if ($record->sms > 0) $b[] = $record->sms.' SMS';
                        
                        foreach($record->appsExentas as $app) {
                            $b[] = $app->nombre_app;
                        }

                        return empty($b) ? 'Solo Servicios Base' : implode(', ', $b);
                    })
                    ->badge()
                    ->color('info'),
            ])
            ->actions([
                Action::make('comprar')
                    ->label('Comprar')
                    ->button()
                    ->color('success')
                    ->icon('heroicon-m-shopping-cart')
                    ->requiresConfirmation()
                    ->modalHeading('Confirmar Compra')
                    ->modalDescription(fn (Paquete $record) => "¿Seguro que deseas comprar '{$record->nombre_paquete}' por Bs. {$record->costo}?")
                    ->action(function (Paquete $record) {
                        $this->comprarPaquete($record);
                    }),
            ]);
    }

    protected function comprarPaquete(Paquete $paquete)
    {
        $user = auth()->user();
        $linea = Linea::where('id_cliente', $user->id_cliente)->first();

        if (!$linea) {
            Notification::make()->title('Error')->body('No tienes una línea activa.')->danger()->send();
            return;
        }

        $bolsillo = Bolsillo::where('id_linea', $linea->id_linea)->first();

        if (!$bolsillo || $bolsillo->saldo_dinero < $paquete->costo) {
            Notification::make()->title('Saldo Insuficiente')->body('Recarga tu cuenta para comprar este paquete.')->warning()->send();
            return;
        }

        DB::beginTransaction();
        try {
            // 1. Descontar dinero
            $bolsillo->saldo_dinero -= $paquete->costo;

            // 2. Extraer beneficios de las columnas oficiales
            $bolsillo->saldo_megas += $paquete->megas ?? 0;
            $bolsillo->saldo_minutos += $paquete->minutos ?? 0;
            // Ojo: WhatsApp Ilimitado y Redes Sociales Ilimitadas 
            // se manejan lógicamente verificando si el usuario tiene una BolsaActiva vigente.
            
            $bolsillo->save();

            // 3. Registrar Bolsa Activa
            BolsaActiva::create([
                'id_linea' => $linea->id_linea,
                'id_paquete' => $paquete->id_paquete,
                'fecha_activacion' => Carbon::now(),
                'fecha_expiracion' => Carbon::now()->addDays($paquete->duracion_dias),
            ]);

            DB::commit();
            Notification::make()->title('¡Compra Exitosa!')->body("Disfruta tu paquete: {$paquete->nombre_paquete}")->success()->send();

        } catch (\Exception $e) {
            DB::rollBack();
            Notification::make()->title('Error')->body($e->getMessage())->danger()->send();
        }
    }
}
