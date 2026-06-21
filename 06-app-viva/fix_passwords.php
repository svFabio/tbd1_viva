<?php
// Script para resetear TODAS las contraseñas a formato Laravel bcrypt
// Ejecutar con: php artisan tinker fix_passwords.php

use App\Models\User;
use Illuminate\Support\Facades\Hash;

$users = User::all();
$count = 0;

foreach ($users as $user) {
    $user->password_hash = Hash::make('password123');
    $user->save();
    $count++;
    echo "Actualizado: {$user->username} (id_cliente: {$user->id_cliente})\n";
}

echo "\n=== {$count} usuarios actualizados con contraseña: password123 ===\n";
