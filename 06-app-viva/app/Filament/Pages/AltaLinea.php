<?php

namespace App\Filament\Pages;

use Filament\Pages\Page;
use Filament\Forms\Contracts\HasForms;
use Filament\Forms\Concerns\InteractsWithForms;
use Filament\Forms\Form;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Section;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Tabs;
use Filament\Forms\Components\Tabs\Tab;
use Filament\Forms\Components\Hidden;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Filament\Notifications\Notification;
use App\Models\User;

class AltaLinea extends Page implements HasForms
{
    use InteractsWithForms;

    protected static ?string $navigationIcon = 'heroicon-o-building-office';
    protected static ?string $navigationLabel = 'Agencia CRM (Alta)';
    protected static ?string $title = 'Simulador Agencia VIVA: Alta de Línea (CRM)';
    protected static ?string $slug = 'agencia-alta-cliente';

    protected static string $view = 'filament.pages.alta-linea';

    public ?array $data = [];

    public static function canAccess(): bool
    {
        // SOLO usuarios con rol_agencia pueden acceder (dinámico, no hardcodeado)
        return auth()->user()?->rol_db === 'rol_agencia';
    }

    public function mount(): void
    {
        $this->form->fill();
    }

    public function form(Form $form): Form
    {
        return $form
            ->schema([
                Tabs::make('Tipo de Cliente')
                    ->tabs([
                        Tab::make('Persona Natural')
                            ->icon('heroicon-o-user')
                            ->schema([
                                Select::make('persona_natural_id')
                                    ->label('Seleccionar Cliente (Persona Natural)')
                                    ->options(function () {
                                        return DB::table('clientes.Persona_Natural')
                                            ->select('id_cliente', DB::raw("nombre || ' ' || apellido || ' - CI: ' || ci as label"))
                                            ->pluck('label', 'id_cliente');
                                    })
                                    ->searchable()
                                    ->reactive()
                                    ->afterStateUpdated(function ($state, callable $set) {
                                        if ($state) {
                                            // Reset Empresa
                                            $set('empresa_id', null);
                                            $set('razon_social', null);
                                            $set('nit', null);
                                            $set('representante_legal', null);
                                            $set('empresa_ciudad', null);

                                            $persona = DB::table('clientes.Persona_Natural')->where('id_cliente', $state)->first();
                                            $cliente = DB::table('clientes.Cliente')->where('id_cliente', $state)->first();
                                            if ($persona && $cliente) {
                                                $set('nombre', $persona->nombre);
                                                $set('apellido', $persona->apellido);
                                                $set('ci', $persona->ci);
                                                $set('correo', $persona->correo);
                                                $set('ciudad', $cliente->ciudad);
                                            }
                                            
                                            // Check credentials
                                            $user = DB::table('seguridad.Usuario_Sistema')->where('id_cliente', $state)->first();
                                            if ($user) {
                                                $set('has_credentials', true);
                                                $set('existing_username', $user->username);
                                            } else {
                                                $set('has_credentials', false);
                                                $set('existing_username', null);
                                            }
                                        } else {
                                            $set('nombre', null);
                                            $set('apellido', null);
                                            $set('ci', null);
                                            $set('correo', null);
                                            $set('ciudad', null);
                                            $set('has_credentials', false);
                                            $set('existing_username', null);
                                        }
                                    }),

                                Hidden::make('has_credentials')
                                    ->default(false),
                                
                                Section::make('Detalle del Cliente')
                                    ->schema([
                                        TextInput::make('nombre')->disabled(),
                                        TextInput::make('apellido')->disabled(),
                                        TextInput::make('ci')->label('CI')->disabled(),
                                        TextInput::make('correo')->disabled(),
                                        TextInput::make('ciudad')->disabled(),
                                    ])
                                    ->columns(2)
                                    ->visible(fn ($get) => $get('persona_natural_id') !== null),

                                Section::make('Credenciales Web (Para usar App Mi VIVA)')
                                    ->schema([
                                        TextInput::make('existing_username')
                                            ->label('Nombre de Usuario Registrado')
                                            ->disabled()
                                            ->visible(fn ($get) => $get('has_credentials') === true),

                                        TextInput::make('username')
                                            ->label('Nombre de Usuario Nuevo')
                                            ->required(fn ($get) => $get('persona_natural_id') !== null && $get('has_credentials') !== true)
                                            ->maxLength(50)
                                            ->unique(config('database.default') . '.' . (new User())->getTable(), 'username')
                                            ->visible(fn ($get) => $get('persona_natural_id') !== null && $get('has_credentials') !== true),

                                        TextInput::make('password')
                                            ->password()
                                            ->required(fn ($get) => $get('persona_natural_id') !== null && $get('has_credentials') !== true)
                                            ->confirmed()
                                            ->visible(fn ($get) => $get('persona_natural_id') !== null && $get('has_credentials') !== true),

                                        TextInput::make('password_confirmation')
                                            ->password()
                                            ->required(fn ($get) => $get('persona_natural_id') !== null && $get('has_credentials') !== true)
                                            ->visible(fn ($get) => $get('persona_natural_id') !== null && $get('has_credentials') !== true),
                                    ])
                                    ->visible(fn ($get) => $get('persona_natural_id') !== null)
                                    ->columns(3),
                            ]),

                        Tab::make('Empresa')
                            ->icon('heroicon-o-building-office-2')
                            ->schema([
                                Select::make('empresa_id')
                                    ->label('Seleccionar Cliente (Empresa)')
                                    ->options(function () {
                                        return DB::table('clientes.Empresa')
                                            ->select('id_cliente', DB::raw("razon_social || ' - NIT: ' || nit as label"))
                                            ->pluck('label', 'id_cliente');
                                    })
                                    ->searchable()
                                    ->reactive()
                                    ->afterStateUpdated(function ($state, callable $set) {
                                        if ($state) {
                                            // Reset Persona Natural
                                            $set('persona_natural_id', null);
                                            $set('nombre', null);
                                            $set('apellido', null);
                                            $set('ci', null);
                                            $set('correo', null);
                                            $set('ciudad', null);
                                            $set('has_credentials', false);
                                            $set('existing_username', null);
                                            $set('username', null);
                                            $set('password', null);
                                            $set('password_confirmation', null);

                                            $empresa = DB::table('clientes.Empresa')->where('id_cliente', $state)->first();
                                            $cliente = DB::table('clientes.Cliente')->where('id_cliente', $state)->first();
                                            if ($empresa && $cliente) {
                                                $set('razon_social', $empresa->razon_social);
                                                $set('nit', $empresa->nit);
                                                $set('representante_legal', $empresa->representante_legal);
                                                $set('empresa_ciudad', $cliente->ciudad);
                                            }
                                        } else {
                                            $set('razon_social', null);
                                            $set('nit', null);
                                            $set('representante_legal', null);
                                            $set('empresa_ciudad', null);
                                        }
                                    }),

                                Section::make('Detalle de la Empresa')
                                    ->schema([
                                        TextInput::make('razon_social')->label('Razón Social')->disabled(),
                                        TextInput::make('nit')->label('NIT')->disabled(),
                                        TextInput::make('representante_legal')->label('Representante Legal')->disabled(),
                                        TextInput::make('empresa_ciudad')->label('Ciudad')->disabled(),
                                    ])
                                    ->columns(2)
                                    ->visible(fn ($get) => $get('empresa_id') !== null),
                            ]),
                    ])
                    ->id('tipo_cliente_tabs'),

                Section::make('Datos de la Línea y Plan')
                    ->schema([
                        Select::make('id_plan')
                            ->label('Plan a contratar')
                            ->options(function () {
                                return DB::table('lineas.Plan')->pluck('nombre_plan', 'id_plan');
                            })
                            ->required()
                            ->searchable(),
                    ]),
            ])
            ->statePath('data');
    }

    public function create()
    {
        $data = $this->form->getState();

        $clienteId = null;
        $esPersonaNatural = false;

        if (!empty($data['persona_natural_id'])) {
            $clienteId = $data['persona_natural_id'];
            $esPersonaNatural = true;
        } elseif (!empty($data['empresa_id'])) {
            $clienteId = $data['empresa_id'];
            $esPersonaNatural = false;
        } else {
            Notification::make()
                ->title('Error de Validación')
                ->body('Debe seleccionar un cliente (Persona Natural o Empresa).')
                ->danger()
                ->send();
            return;
        }

        try {
            DB::beginTransaction();

            // 1. Asignar SIM Card disponible (o crear una si no hay)
            $sim = DB::table('lineas.SIM_Card')->where('estado', 'Disponible')->first();
            if ($sim) {
                $idSimActivo = $sim->id_sim;
                DB::table('lineas.SIM_Card')->where('id_sim', $idSimActivo)->update(['estado' => 'Activo']);
            } else {
                $idSimActivo = DB::table('lineas.SIM_Card')->insertGetId([
                    'iccid' => '89591' . str_pad(rand(0, 99999999999999), 14, '0', STR_PAD_LEFT),
                    'imsi' => '73602' . str_pad(rand(0, 9999999999), 10, '0', STR_PAD_LEFT),
                    'estado' => 'Activo'
                ], 'id_sim');
            }

            // 2. Asignar Línea con Número Aleatorio VIVA (Ej: 707XXXXX)
            // Reintentamos hasta encontrar un número que no exista ya en la BD
            do {
                $numeroTelefono = '707' . rand(10000, 99999);
            } while (DB::table('lineas.Linea')->where('numero_telefono', $numeroTelefono)->exists());

            $lineaId = DB::table('lineas.Linea')->insertGetId([
                'id_cliente' => $clienteId,
                'id_plan' => $data['id_plan'],
                'id_sim_activo' => $idSimActivo,
                'numero_telefono' => $numeroTelefono,
                'estado' => 'Activo'
            ], 'id_linea');

            // 3. Crear su Bolsillo (Megas, Minutos y SMS en 0)
            DB::table('finanzas.Bolsillo')->insert([
                'id_linea' => $lineaId,
                'saldo_dinero' => 0.00,
                'saldo_megas' => 0.00,
                'saldo_minutos' => 0,
                'saldo_sms' => 0
            ]);

            // 4. Crear su Usuario de App si es Persona Natural y no posee credenciales web
            if ($esPersonaNatural && !empty($data['username'])) {
                // Verificar doblemente que no se inserte un duplicado de id_cliente en seguridad.Usuario_Sistema
                $exists = DB::table('seguridad.Usuario_Sistema')->where('id_cliente', $clienteId)->exists();
                if (!$exists) {
                    User::create([
                        'username' => $data['username'],
                        'password_hash' => Hash::make($data['password']),
                        'id_cliente' => $clienteId
                    ]);
                }
            }

            DB::commit();

            Notification::make()
                ->title('Transacción Exitosa')
                ->body('Se dio de alta la línea exitosamente. Número asignado: ' . $numeroTelefono)
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
