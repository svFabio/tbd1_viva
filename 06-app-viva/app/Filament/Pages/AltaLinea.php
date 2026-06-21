<?php

namespace App\Filament\Pages;

use Filament\Pages\Page;
use Filament\Forms\Contracts\HasForms;
use Filament\Forms\Concerns\InteractsWithForms;
use Filament\Forms\Form;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Section;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Filament\Notifications\Notification;
use App\Models\User;

class AltaLinea extends Page implements HasForms
{
    use InteractsWithForms;

    protected static ?string $navigationIcon = 'heroicon-o-building-office';
    protected static ?string $navigationLabel = '🏢 Agencia CRM (Alta)';
    protected static ?string $title = 'Simulador Agencia VIVA: Alta de Nuevo Cliente';
    protected static ?string $slug = 'agencia-alta-cliente';

    protected static string $view = 'filament.pages.alta-linea';

    public ?array $data = [];

    public function mount(): void
    {
        $this->form->fill();
    }

    public function form(Form $form): Form
    {
        return $form
            ->schema([
                Section::make('Datos Personales (Persona Natural)')
                    ->schema([
                        TextInput::make('nombre')
                            ->required()
                            ->maxLength(100),
                        TextInput::make('apellido')
                            ->required()
                            ->maxLength(100),
                        TextInput::make('ci')
                            ->label('Carnet de Identidad (CI)')
                            ->required()
                            ->maxLength(20)
                            // Validación inteligente evitando el schema conflictivo
                            ->unique(\App\Models\PersonaNatural::class, 'ci'),
                        TextInput::make('correo')
                            ->email()
                            ->maxLength(100),
                    ])->columns(2),

                Section::make('Credenciales Web (Para usar App Mi VIVA)')
                    ->schema([
                        TextInput::make('username')
                            ->label('Nombre de Usuario')
                            ->required()
                            ->maxLength(50)
                            ->unique(User::class, 'username'),
                        TextInput::make('password')
                            ->password()
                            ->required()
                            ->confirmed(),
                        TextInput::make('password_confirmation')
                            ->password()
                            ->required(),
                    ])->columns(3),
            ])
            ->statePath('data');
    }

    public function create()
    {
        $data = $this->form->getState();

        try {
            DB::beginTransaction();

            // 1. Insertar Cliente
            $clienteId = DB::table('clientes.Cliente')->insertGetId([
                'fecha_registro' => now(),
                'estado' => 'Activo'
            ], 'id_cliente');

            // 2. Insertar Persona Natural
            DB::table('clientes.Persona_Natural')->insert([
                'id_cliente' => $clienteId,
                'nombre' => $data['nombre'],
                'apellido' => $data['apellido'],
                'ci' => $data['ci'],
                'correo' => $data['correo']
            ]);

            // 3. Asignar Línea con Número Aleatorio VIVA (Ej: 707XXXXX)
            $numeroTelefono = '707' . rand(10000, 99999);
            $lineaId = DB::table('lineas.Linea')->insertGetId([
                'id_cliente' => $clienteId,
                'id_plan' => 1,
                'id_sim' => 1,
                'numero_telefono' => $numeroTelefono,
                'estado' => 'Activo'
            ], 'id_linea');

            // 4. Crear su Bolsillo (Megas, Minutos y SMS en 0)
            DB::table('finanzas.Bolsillo')->insert([
                'id_linea' => $lineaId,
                'saldo_dinero' => 0.00,
                'saldo_megas' => 0.00,
                'saldo_minutos' => 0,
                'saldo_sms' => 0
            ]);

            // 5. Crear su Usuario de App
            User::create([
                'username' => $data['username'],
                'password_hash' => Hash::make($data['password']),
                'id_cliente' => $clienteId
            ]);

            DB::commit();

            Notification::make()
                ->title('Transacción Exitosa (5 tablas)')
                ->body('Cliente inscrito. Se le asignó el número: ' . $numeroTelefono)
                ->success()
                ->duration(10000)
                ->send();

            $this->form->fill();

        } catch (\Exception $e) {
            DB::rollBack();
            
            Notification::make()
                ->title('Error en la Transacción (Rollback ejecutado)')
                ->body($e->getMessage())
                ->danger()
                ->send();
        }
    }
}
