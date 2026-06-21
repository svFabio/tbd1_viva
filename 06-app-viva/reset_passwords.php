<?php
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

User::query()->update(['password_hash' => Hash::make('password123')]);
$u = User::first();
if ($u) {
    $p = DB::table('clientes.Persona_Natural')->where('id_cliente', $u->id_cliente)->first();
    $l = DB::table('lineas.Linea')->where('id_cliente', $u->id_cliente)->first();
    echo "\n\n============\nPRUEBA ESTE USUARIO:\nCORREO: " . ($p ? $p->correo : 'N/A') . "\nCELULAR: " . ($l ? $l->numero_telefono : 'N/A') . "\nCONTRASEÑA: password123\n============\n\n";
} else {
    echo "NO HAY USUARIOS\n";
}
