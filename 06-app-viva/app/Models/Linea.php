<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Linea extends Model
{
    protected $table = 'lineas.Linea';
    protected $primaryKey = 'id_linea';
    public $timestamps = false;
    protected $guarded = [];
}
