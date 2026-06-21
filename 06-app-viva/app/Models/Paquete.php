<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Paquete extends Model
{
    protected $table = 'servicios.Paquete';
    protected $primaryKey = 'id_paquete';
    public $timestamps = false;
    protected $guarded = [];
}
