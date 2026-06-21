<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Paquete extends Model
{
    protected $table = 'servicios.Paquete';
    protected $primaryKey = 'id_paquete';
    public $timestamps = false;
    protected $guarded = [];

    public function appsExentas()
    {
        return $this->hasMany(AppExentaEnBolsa::class, 'id_paquete', 'id_paquete');
    }
}
