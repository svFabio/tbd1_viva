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
                \Filament\Forms\Components\Toggle::make('is_celular')
                    ->label('Ingresar con número de celular')
                    ->reactive()
                    ->default(false),

                \Filament\Forms\Components\TextInput::make('identificador')
                    ->label('Correo Electrónico o Usuario')
                    ->placeholder('correo@empresa.com o u.comercial')
                    ->required(fn (callable $get) => !$get('is_celular'))
                    ->hidden(fn (callable $get) => $get('is_celular'))
                    ->autocomplete('username')
                    ->autofocus(),

                \Filament\Forms\Components\TextInput::make('celular')
                    ->label('Número de Celular')
                    ->placeholder('Ej: 70123456')
                    ->prefix('🇧🇴 +591')
                    ->tel()
                    ->numeric()
                    ->minLength(8)
                    ->maxLength(8)
                    ->required(fn (callable $get) => $get('is_celular'))
                    ->hidden(fn (callable $get) => !$get('is_celular')),

                $this->getPasswordFormComponent(),
                $this->getRememberFormComponent(),
            ])
            ->statePath('data');
    }

    protected function getCredentialsFromFormData(array $data): array
    {
        $password = $data['password'];
        $is_celular = $data['is_celular'] ?? false;
        
        $identificador = '';
        if ($is_celular) {
            $identificador = '591' . trim($data['celular'] ?? '');
        } else {
            $identificador = trim($data['identificador'] ?? '');
        }

        $id_cliente = null;

        // 1. Verificamos si es un correo electrónico válido
        if (!$is_celular && filter_var($identificador, FILTER_VALIDATE_EMAIL)) {
            $persona = DB::table('clientes.Persona_Natural')->where('correo', $identificador)->first();
            if ($persona) {
                $id_cliente = $persona->id_cliente;
            }
        } 
        // 2. Verificamos si es un número de celular de Bolivia (Prefijo 591 y 8 dígitos más)
        elseif ($is_celular && preg_match('/^591([0-9]{8})$/', $identificador, $matches)) {
            $numero_sin_prefijo = $matches[1];
            $linea = DB::table('lineas.Linea')->where('numero_telefono', $numero_sin_prefijo)->first();
            if ($linea) {
                $id_cliente = $linea->id_cliente;
            }
        } 
        // 3. Verificamos si es un usuario administrador (username directo)
        elseif (!$is_celular && preg_match('/^[a-zA-Z0-9_.]+$/', $identificador)) {
            $admin = DB::table('seguridad.Usuario_Sistema')
                ->where('username', $identificador)
                ->whereNull('id_cliente')
                ->first();
            
            if ($admin) {
                return [
                    'username' => $admin->username,
                    'password' => $password,
                ];
            } else {
                throw ValidationException::withMessages([
                    'data.identificador' => 'Credenciales incorrectas o usuario no autorizado.',
                ]);
            }
        }
        else {
            // Si no cumple el formato, detenemos el login
            throw ValidationException::withMessages([
                'data.identificador' => 'El formato es inválido. Revise sus datos.',
                'data.celular' => 'El número debe tener 8 dígitos.',
            ]);
        }

        // Si encontramos al cliente, buscamos su registro de autenticación en Usuario_Sistema

        $username = null;
        if ($id_cliente) {
            $usuario = DB::table('seguridad.Usuario_Sistema')->where('id_cliente', $id_cliente)->first();
            if ($usuario) {
                $username = $usuario->username;
            }
        }

        // Devolvemos las credenciales a Laravel. Si $username es null, Laravel rechazará el login automáticamente.
        return [
            'username' => $username ?? '---no-encontrado---',
            'password' => $password,
        ];
    }
}
