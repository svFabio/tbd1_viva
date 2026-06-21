<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class BolsaActiva extends Model
{
    protected $table = 'servicios.Bolsa_Activa';
    protected $primaryKey = 'id_bolsa_activa';
    public $timestamps = false;
    protected $guarded = [];
}
