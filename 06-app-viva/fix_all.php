<?php
// Script todo-en-uno: genera hash con PHP y actualiza directamente en PostgreSQL
$hash = password_hash('password123', PASSWORD_BCRYPT);

$dsn = 'pgsql:host=contenedor-postgres-viva;port=5432;dbname=bd-viva';
$pdo = new PDO($dsn, 'postgres', 'tbdviva');

$stmt = $pdo->prepare('UPDATE seguridad."Usuario_Sistema" SET password_hash = :hash');
$stmt->execute(['hash' => $hash]);
$count = $stmt->rowCount();

echo "=== LISTO: {$count} usuarios actualizados ===\n";
echo "Hash usado: {$hash}\n";
echo "Contraseña: password123\n";
