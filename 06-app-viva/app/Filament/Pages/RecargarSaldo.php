<?php

namespace App\Filament\Pages;

use Filament\Pages\Page;
use Filament\Forms\Contracts\HasForms;
use Filament\Forms\Concerns\InteractsWithForms;
use Filament\Forms\Form;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Select;
use Filament\Actions\Action;
use Filament\Notifications\Notification;
use Illuminate\Support\Facades\DB;
use App\Models\Recarga;
use App\Models\Linea;

class RecargarSaldo extends Page implements HasForms
{
    use InteractsWithForms;

    protected static ?string $navigationIcon = 'heroicon-o-credit-card';
    protected static ?string $navigationLabel = 'Recargar Saldo';
    protected static ?string $title = 'Recargar Saldo VIVA';
    protected static ?int $navigationSort = 1;

    protected static string $view = 'filament.pages.recargar-saldo';

    public ?array $data = [];

    public function mount(): void
    {
        $this->form->fill();
    }

    public static function canAccess(): bool
    {
        return auth()->user()->id_cliente !== null;
    }

    public function form(Form $form): Form
    {
        $lineaId = session('current_linea_id', Linea::where('id_cliente', auth()->user()->id_cliente)->value('id_linea'));
        
        $esDiaDobleCarga = (date('j') == 1) || DB::table('comercial.Promocion')
            ->where('nombre_promo', 'ILIKE', '%Doble Carga%')
            ->whereRaw('CURRENT_TIMESTAMP BETWEEN fecha_inicio AND fecha_fin')
            ->exists();

        $yaUsoBono = DB::table('finanzas.Recarga')
            ->where('id_linea', $lineaId)
            ->where('aplicar_bono', true)
            ->whereRaw("date_trunc('month', fecha_recarga) = date_trunc('month', CURRENT_TIMESTAMP)")
            ->exists();

        $puedeActivarBono = $esDiaDobleCarga && !$yaUsoBono;
        $mensajeBono = '';
        if (!$esDiaDobleCarga) {
            $mensajeBono = 'Hoy no es día de Doble Carga.';
        } elseif ($yaUsoBono) {
            $mensajeBono = 'Ya utilizaste tu Doble Carga este mes.';
        } else {
            $mensajeBono = '¡Tienes disponible tu Doble Carga de este mes!';
        }

        return $form
            ->schema([
                TextInput::make('monto')
                    ->label('Monto a Recargar')
                    ->prefix('Bs.')
                    ->numeric()
                    ->required()
                    ->minValue(1)
                    ->maxValue(500),
                Select::make('metodo_pago')
                    ->label('Método de Pago')
                    ->options([
                        'tarjeta' => 'Tarjeta de Crédito / Débito',
                        'qr' => 'Pago por QR Simple',
                        'tigo_money' => 'Tigo Money / Billetera Móvil'
                    ])
                    ->required()
                    ->default('qr'),
                \Filament\Forms\Components\Toggle::make('aplicar_bono')
                    ->label('Aplicar Doble Carga')
                    ->helperText($mensajeBono)
                    ->disabled(!$puedeActivarBono)
                    ->default(false),
            ])
            ->statePath('data');
    }

    public function submit(): void
    {
        $monto = $this->data['monto'];
        $aplicarBono = $this->data['aplicar_bono'] ?? false;
        $lineaId = session('current_linea_id', Linea::where('id_cliente', auth()->user()->id_cliente)->value('id_linea'));

        if (!$lineaId) {
            Notification::make()->title('Error')->body('No tienes una línea activa seleccionada.')->danger()->send();
            return;
        }

        try {
            DB::transaction(function () use ($lineaId, $monto, $aplicarBono) {
                // Configurar el entorno de base de datos como rol_app (simulado por el middleware o aquí si es necesario)
                // DB::statement("SET ROLE rol_app");

                Recarga::create([
                    'id_linea' => $lineaId,
                    'monto' => $monto,
                    'aplicar_bono' => $aplicarBono,
                ]);
            });

            Notification::make()
                ->title('¡Recarga Exitosa!')
                ->body("Has recargado Bs. {$monto} a tu línea" . ($aplicarBono ? ' ¡con Doble Carga aplicada!' : '') . " Revisa tu bolsillo.")
                ->success()
                ->send();
                
            $this->form->fill();
            
        } catch (\Exception $e) {
            Notification::make()
                ->title('Error al procesar la recarga')
                ->body($e->getMessage())
                ->danger()
                ->send();
        }
    }
}
