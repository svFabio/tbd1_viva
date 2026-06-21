<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Empresa extends Model
{
    protected $table = 'clientes.Empresa';
    protected $primaryKey = 'id_empresa';
    public $timestamps = false;
    protected $guarded = [];
}
