<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;

class Paquete extends Model
{
    protected $table = 'servicios.Paquete';
    protected $primaryKey = 'id_paquete';
    public $timestamps = false;
    protected $guarded = [];

    // ── Scope global: la app nunca ve paquetes inactivos
    protected static function booted(): void
    {
        static::addGlobalScope('activo', function (Builder $query) {
            $query->where('activo', true);
        });
    }

    // ── Baja lógica (en lugar de DELETE)
    public function desactivar(): void
    {
        $this->update(['activo' => false]);
    }

    // ── Reactivar un paquete desactivado
    public function activar(): void
    {
        $this->update(['activo' => true]);
    }

    public function appsExentas()
    {
        return $this->hasMany(AppExentaEnBolsa::class, 'id_paquete', 'id_paquete');
    }
}
