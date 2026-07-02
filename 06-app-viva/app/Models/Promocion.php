<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Promocion extends Model
{
    use HasFactory;

    protected $table = 'comercial.Promocion';
    protected $primaryKey = 'id_promocion';
    public $timestamps = false;

    protected $fillable = [
        'nombre_promo',
        'descripcion',
        'fecha_inicio',
        'fecha_fin',
    ];

    protected $casts = [
        'fecha_inicio' => 'datetime',
        'fecha_fin' => 'datetime',
    ];

    public function condiciones(): HasMany
    {
        return $this->hasMany(CondicionPromocion::class, 'id_promocion', 'id_promocion');
    }
}
