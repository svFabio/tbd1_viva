<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Auditoria extends Model
{
    // Conectamos con el esquema de seguridad
    protected $table = 'seguridad.Auditoria';
    protected $primaryKey = 'id_auditoria';
    
    // La tabla no usa created_at ni updated_at de Laravel, usa CURRENT_TIMESTAMP de Postgres
    public $timestamps = false;
    
    protected $guarded = [];

    // Castear el JSONB para que Filament lo pueda leer bonito
    protected $casts = [
        'fecha' => 'datetime',
    ];
}
