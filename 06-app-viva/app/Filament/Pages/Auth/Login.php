<?php

namespace App\Filament\Pages\Auth;

use Filament\Pages\Auth\Login as BaseLogin;
use Filament\Forms\Form;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Component;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\DB;

class Login extends BaseLogin
{
    public function form(Form $form): Form
    {
        return $form
            ->schema([
                // TAB PRINCIPAL: Administrador vs Cliente VIVA
                // Por defecto se muestra "Cliente VIVA" primero
                \Filament\Forms\Components\ToggleButtons::make('login_type')
                    ->label('')
                    ->options([
                        'celular' => 'Cliente VIVA',
                        'email'   => 'Administrador',
                    ])
                    ->icons([
                        'celular' => 'heroicon-o-device-phone-mobile',
                        'email'   => 'heroicon-o-user',
                    ])
                    ->grouped()
                    ->extraAttributes(['class' => 'flex justify-center'])
                    ->default('celular')
                    ->reactive(),

                // ─── SECCIÓN CLIENTE ───────────────────────────────────────
                // Sub-toggle: el cliente elige cómo identificarse
                \Filament\Forms\Components\ToggleButtons::make('cliente_id_tipo')
                    ->label('Iniciar sesión con')
                    ->options([
                        'numero'  => 'Número de celular',
                        'usuario' => 'Usuario / Correo',
                    ])
                    ->icons([
                        'numero'  => 'heroicon-o-phone',
                        'usuario' => 'heroicon-o-at-symbol',
                    ])
                    ->grouped()
                    ->default('numero')
                    ->reactive()
                    ->hidden(fn (callable $get) => $get('login_type') !== 'celular'),

                // Campo: Número de celular (opción principal del cliente)
                \Filament\Forms\Components\TextInput::make('celular')
                    ->label('Número de Celular')
                    ->placeholder('Ej: 70123456')
                    ->prefix('+591')
                    ->extraInputAttributes([
                        'pattern' => '[0-9]*',
                        'style'   => 'background-image: url("https://flagcdn.com/w20/bo.png"); background-repeat: no-repeat; background-position: 12px center; padding-left: 40px;'
                    ])
                    ->tel()
                    ->minLength(8)
                    ->maxLength(8)
                    ->required(fn (callable $get) => $get('login_type') === 'celular' && $get('cliente_id_tipo') === 'numero')
                    ->hidden(fn (callable $get) => $get('login_type') !== 'celular' || $get('cliente_id_tipo') !== 'numero'),

                // Campo: Username o correo (opción alternativa del cliente)
                \Filament\Forms\Components\TextInput::make('cliente_identificador')
                    ->label('Usuario o Correo Electrónico')
                    ->placeholder('mi_usuario o correo@gmail.com')
                    ->autocomplete('username')
                    ->required(fn (callable $get) => $get('login_type') === 'celular' && $get('cliente_id_tipo') === 'usuario')
                    ->hidden(fn (callable $get) => $get('login_type') !== 'celular' || $get('cliente_id_tipo') !== 'usuario'),

                // ─── SECCIÓN ADMINISTRADOR ─────────────────────────────────
                \Filament\Forms\Components\TextInput::make('identificador')
                    ->label('Correo Electrónico o Usuario')
                    ->placeholder('correo@empresa.com o u.comercial')
                    ->required(fn (callable $get) => $get('login_type') === 'email')
                    ->hidden(fn (callable $get) => $get('login_type') !== 'email')
                    ->autocomplete('username'),

                $this->getPasswordFormComponent(),
                $this->getRememberFormComponent(),
            ])
            ->statePath('data');
    }

    protected function getCredentialsFromFormData(array $data): array
    {
        $password   = $data['password'];
        $login_type = $data['login_type'] ?? 'celular';

        $id_cliente = null;

        // ── CLIENTE VIVA ──────────────────────────────────────────────
        if ($login_type === 'celular') {
            $cliente_id_tipo = $data['cliente_id_tipo'] ?? 'numero';

            if ($cliente_id_tipo === 'numero') {
                // Login por número de celular
                $numero = '591' . trim($data['celular'] ?? '');
                if (preg_match('/^591([0-9]{8})$/', $numero, $matches)) {
                    $linea = DB::table('lineas.Linea')->where('numero_telefono', $matches[1])->first();
                    if ($linea) {
                        $id_cliente = $linea->id_cliente;
                    }
                } else {
                    throw ValidationException::withMessages([
                        'data.celular' => 'El número debe tener 8 dígitos.',
                    ]);
                }
            } else {
                // Login por username o correo
                $identificador = trim($data['cliente_identificador'] ?? '');
                if (filter_var($identificador, FILTER_VALIDATE_EMAIL)) {
                    $persona = DB::table('clientes.Persona_Natural')->where('correo', $identificador)->first();
                    if ($persona) {
                        $id_cliente = $persona->id_cliente;
                    }
                } else {
                    $usuario = DB::table('seguridad.Usuario_Sistema')
                        ->where('username', $identificador)
                        ->whereNotNull('id_cliente')
                        ->first();
                    if ($usuario) {
                        $id_cliente = $usuario->id_cliente;
                    }
                }
            }

            // Buscamos el username de autenticación a partir del id_cliente
            if ($id_cliente) {
                $usuario = DB::table('seguridad.Usuario_Sistema')->where('id_cliente', $id_cliente)->first();
                if ($usuario) {
                    return ['username' => $usuario->username, 'password' => $password];
                }
            }

            throw ValidationException::withMessages([
                'data.celular' => 'Credenciales incorrectas. Verifique sus datos.',
            ]);
        }

        // ── ADMINISTRADOR ─────────────────────────────────────────────
        $identificador = trim($data['identificador'] ?? '');

        if (filter_var($identificador, FILTER_VALIDATE_EMAIL)) {
            $admin = DB::table('seguridad.Usuario_Sistema')
                ->where('correo', $identificador)
                ->whereNull('id_cliente')
                ->first();
        } else {
            $admin = DB::table('seguridad.Usuario_Sistema')
                ->where('username', $identificador)
                ->whereNull('id_cliente')
                ->first();
        }

        if ($admin) {
            return ['username' => $admin->username, 'password' => $password];
        }

        throw ValidationException::withMessages([
            'data.identificador' => 'Credenciales incorrectas o usuario no autorizado.',
        ]);
    }
}
