<?php
// public/api/db.php
// CONFIGURAÇÃO DO MySQL — AJUSTE AQUI AS CREDENCIAIS

$db_host = '127.0.0.1';
$db_user = 'camp_user';
$db_pass = 'camp_pass';
$db_name = 'campeonato';
$db_port = 3306;

$mysqli = new mysqli($db_host, $db_user, $db_pass, $db_name, $db_port);

if ($mysqli->connect_errno) {
    http_response_code(500);
    header('Content-Type: application/json');
    echo json_encode(['error' => 'Erro ao conectar MySQL', 'detail' => $mysqli->connect_error]);
    exit;
}

$mysqli->set_charset('utf8mb4');
