<?php
// Genera hash y lo escribe a un archivo para evitar problemas con stdout en PowerShell
$hash = password_hash('password123', PASSWORD_BCRYPT);
file_put_contents('/tmp/hash_output.txt', $hash);
echo "HASH GENERADO Y GUARDADO EN /tmp/hash_output.txt\n";
