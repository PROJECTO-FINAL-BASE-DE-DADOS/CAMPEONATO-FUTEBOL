<?php
declare(strict_types=1);

$DB_HOST = "localhost";
$DB_NAME = "escola_db";
$DB_USER = "root";
$DB_PASS = ""; // XAMPP normalmente é vazio

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

try {
    $conn = new mysqli($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
    $conn->set_charset("utf8mb4");
} catch (mysqli_sql_exception $e) {
    http_response_code(500);
    die("Erro ao conectar na base de dados: " . htmlspecialchars($e->getMessage()));
}
