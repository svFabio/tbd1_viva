<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Bolsillo extends Model
{
    protected $table = 'finanzas.Bolsillo';
    protected $primaryKey = 'id_bolsillo';
    public $timestamps = false;
    protected $guarded = [];
}
