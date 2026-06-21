<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PersonaNatural extends Model
{
    protected $table = 'clientes.Persona_Natural';
    protected $primaryKey = 'id_persona';
    public $timestamps = false;
    protected $guarded = [];
}
