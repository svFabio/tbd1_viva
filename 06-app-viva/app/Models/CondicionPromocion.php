<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CondicionPromocion extends Model
{
    use HasFactory;

    protected $table = 'comercial.Condicion_Promocion';
    protected $primaryKey = 'id_condicion';
    public $timestamps = false;

    protected $fillable = [
        'id_promocion',
        'descripcion_condicion',
    ];

    public function promocion(): BelongsTo
    {
        return $this->belongsTo(Promocion::class, 'id_promocion', 'id_promocion');
    }
}
