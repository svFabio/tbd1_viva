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
                $this->getLoginFormComponent(),
                $this->getPasswordFormComponent(),
                $this->getRememberFormComponent(),
            ])
            ->statePath('data');
    }

    protected function getLoginFormComponent(): Component
    {
        return TextInput::make('identificador')
            ->label('Correo Electrónico o Celular (Ej: 5917xxxxxxx)')
            ->placeholder('591... o correo@empresa.com')
            ->required()
            ->autocomplete('username')
            ->autofocus()
            ->extraInputAttributes(['tabindex' => 1]);
    }

    protected function getCredentialsFromFormData(array $data): array
    {
        $identificador = $data['identificador'];
        $password = $data['password'];

        $id_cliente = null;

        // 1. Verificamos si es un correo electrónico válido
        if (filter_var($identificador, FILTER_VALIDATE_EMAIL)) {
            $persona = DB::table('clientes.Persona_Natural')->where('correo', $identificador)->first();
            if ($persona) {
                $id_cliente = $persona->id_cliente;
            }
        } 
        // 2. Verificamos si es un número de celular de Bolivia (Prefijo 591 y 8 dígitos más)
        elseif (preg_match('/^591([0-9]{8})$/', $identificador, $matches)) {
            $numero_sin_prefijo = $matches[1];
            $linea = DB::table('lineas.Linea')->where('numero_telefono', $numero_sin_prefijo)->first();
            if ($linea) {
                $id_cliente = $linea->id_cliente;
            }
        } 
        else {
            // Si no cumple el formato, detenemos el login
            throw ValidationException::withMessages([
                'data.identificador' => 'El formato es inválido. Debe ser un correo electrónico válido o un número de celular de Bolivia que empiece con 591.',
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
