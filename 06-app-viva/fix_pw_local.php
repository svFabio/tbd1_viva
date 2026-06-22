<?php
use App\Models\User;
use Illuminate\Support\Facades\Hash;

$users = User::all();
$count = 0;
foreach($users as $user) {
    if (!str_starts_with($user->password_hash, '$2y$')) {
        $user->password_hash = Hash::make($user->password_hash);
        $user->save();
        $count++;
        echo "Updated ".$user->identificador."\n";
    }
}
echo "Total updated: ".$count."\n";
