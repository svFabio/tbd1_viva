<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Hidden;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Filament\Models\Contracts\FilamentUser;
use Filament\Models\Contracts\HasName;
use Filament\Panel;
use Illuminate\Support\Facades\DB;

#[Fillable(['username', 'password_hash', 'id_cliente'])]
#[Hidden(['password_hash'])]
class User extends Authenticatable implements FilamentUser, HasName
{
    use HasFactory, Notifiable;

    // 1. Apuntar a la tabla y esquema correcto
    protected $table = 'seguridad.Usuario_Sistema';

    // 2. Definir la llave primaria
    protected $primaryKey = 'id_usuario';

    // 3. Desactivar timestamps automáticos porque tu tabla no los tiene
    public $timestamps = false;

    // 4. Decirle a Laravel cuál es la columna de la contraseña
    public function getAuthPasswordName()
    {
        return 'password_hash';
    }

    // 5. Convertir el hash de PostgreSQL ($2a$) al formato que Laravel espera ($2y$)
    //    Ambos son bcrypt idénticos, solo cambia el prefijo.
    //    Así no necesitamos tocar la base de datos.
    public function getAuthPassword()
    {
        $hash = $this->password_hash;

        // PostgreSQL crypt() usa $2a$, PHP/Laravel espera $2y$
        if (str_starts_with($hash, '$2a$')) {
            $hash = '$2y$' . substr($hash, 4);
        }

        return $hash;
    }

    // 6. Casts (sin 'hashed' para evitar doble-hash al guardar)
    protected function casts(): array
    {
        return [];
    }

    // 7. Nombre para mostrar en Filament (busca el nombre real en Persona_Natural)
    public function getFilamentName(): string
    {
        if ($this->id_cliente) {
            $persona = DB::table('clientes.Persona_Natural')
                ->where('id_cliente', $this->id_cliente)
                ->first();

            if ($persona) {
                return $persona->nombre . ' ' . $persona->apellido;
            }
        }

        return $this->username;
    }

    // 8. Permitir acceso al panel de Filament
    public function canAccessPanel(Panel $panel): bool
    {
        return true;
    }
}
