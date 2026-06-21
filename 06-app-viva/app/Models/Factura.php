<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Factura extends Model
{
    protected $table = 'finanzas.Factura';
    protected $primaryKey = 'id_factura';
    public $timestamps = false;
    protected $guarded = [];
}
