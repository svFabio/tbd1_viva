<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AppExentaEnBolsa extends Model
{
    protected $table = 'servicios.App_Exenta_En_Bolsa';
    protected $primaryKey = 'id_app';
    public $timestamps = false;
    protected $guarded = [];

    public function paquete()
    {
        return $this->belongsTo(Paquete::class, 'id_paquete', 'id_paquete');
    }
}
