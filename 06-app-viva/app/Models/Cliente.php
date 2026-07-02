<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Cliente extends Model
{
    protected $table = 'clientes.Cliente';
    protected $primaryKey = 'id_cliente';
    public $timestamps = false;
    protected $guarded = [];

    public function personaNatural(): HasOne
    {
        return $this->hasOne(PersonaNatural::class, 'id_cliente', 'id_cliente');
    }

    public function empresa(): HasOne
    {
        return $this->hasOne(Empresa::class, 'id_cliente', 'id_cliente');
    }

    public function lineas(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(Linea::class, 'id_cliente', 'id_cliente');
    }
}

