<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Recarga extends Model
{
    protected $table = 'finanzas.Recarga';
    protected $primaryKey = 'id_recarga';
    public $timestamps = false;
    protected $guarded = [];
}
