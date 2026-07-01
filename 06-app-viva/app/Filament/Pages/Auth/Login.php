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
                // Campo: Número de celular (única opción para clientes)
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
                    ->required(fn (callable $get) => $get('login_type') === 'celular')
                    ->hidden(fn (callable $get) => $get('login_type') !== 'celular'),

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
            // Login por número de celular (única opción disponible)
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
