<?php

namespace App\Filament\Pages\Auth;

use Filament\Pages\Auth\Register as BaseRegister;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Form;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

class Register extends BaseRegister
{
    public function form(Form $form): Form
    {
        return $form
            ->schema([
                TextInput::make('nombre')
                    ->label('Nombre')
                    ->required()
                    ->maxLength(100),
                TextInput::make('apellido')
                    ->label('Apellido')
                    ->required()
                    ->maxLength(100),
                TextInput::make('ci')
                    ->label('Carnet de Identidad (CI)')
                    ->required()
                    ->maxLength(20)
                    ->unique('clientes.Persona_Natural', 'ci'),
                TextInput::make('correo')
                    ->label('Correo Electrónico')
                    ->email()
                    ->required()
                    ->maxLength(100),
                TextInput::make('username')
                    ->label('Nombre de Usuario')
                    ->required()
                    ->maxLength(50)
                    ->unique('seguridad.Usuario_Sistema', 'username'),
                $this->getPasswordFormComponent(),
                $this->getPasswordConfirmationFormComponent(),
            ])
            ->statePath('data');
    }

    protected function handleRegistration(array $data): \Illuminate\Database\Eloquent\Model
    {
        DB::beginTransaction();
        try {
            // 1. Insertar el registro principal de Cliente
            $clienteId = DB::table('clientes.Cliente')->insertGetId([
                'fecha_registro' => now(),
                'estado' => 'Activo'
            ], 'id_cliente');

            // 2. Insertar los detalles como Persona_Natural
            DB::table('clientes.Persona_Natural')->insert([
                'id_cliente' => $clienteId,
                'nombre' => $data['nombre'],
                'apellido' => $data['apellido'],
                'ci' => $data['ci'],
                'correo' => $data['correo']
            ]);

            // 3. Crear el Usuario_Sistema ligado al Cliente (Usamos el modelo User esperado por Filament)
            $user = User::create([
                'username' => $data['username'],
                'password_hash' => Hash::make($data['password']),
                'id_cliente' => $clienteId
            ]);

            DB::commit();

            return $user;

        } catch (\Exception $e) {
            DB::rollBack();
            throw $e;
        }
    }
}
