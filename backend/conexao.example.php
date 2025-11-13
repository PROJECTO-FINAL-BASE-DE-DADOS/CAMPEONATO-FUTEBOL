<?php
// conexao.php - exemplo atualizado para usar variáveis de ambiente (opcional)
$DB_HOST = getenv('DB_HOST') ?: '127.0.0.1';
$DB_PORT = getenv('DB_PORT') ?: '3306';
$DB_USER = getenv('DB_USER') ?: 'root';
$DB_PASS = getenv('DB_PASS') ?: '';
$DB_NAME = getenv('DB_NAME') ?: 'campeonato';

$mysqli = new mysqli($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME, (int)$DB_PORT);

if ($mysqli->connect_error) {
    http_response_code(500);
    die("Erro de conexão: " . $mysqli->connect_error);
}
?>
