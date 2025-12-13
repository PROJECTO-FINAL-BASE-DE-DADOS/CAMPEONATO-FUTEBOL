<?php
// public/api/rows.php
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/db.php';

$table = $_GET['table'] ?? '';
if (!preg_match('/^[a-z0-9_\-]+$/i', $table)) {
    echo json_encode([]);
    exit;
}

$check = $mysqli->query("SHOW TABLES LIKE '" . $mysqli->real_escape_string($table) . "'");
if (!$check || $check->num_rows == 0) {
    echo json_encode([]);
    exit;
}

$result = $mysqli->query("SELECT * FROM `" . $mysqli->real_escape_string($table) . "`");
if (!$result) {
    http_response_code(500);
    echo json_encode(['error' => $mysqli->error]);
    exit;
}

$rows = [];
while ($r = $result->fetch_assoc()) {
    $rows[] = array_values($r);
}
echo json_encode([
    'data' => $rows
]);

