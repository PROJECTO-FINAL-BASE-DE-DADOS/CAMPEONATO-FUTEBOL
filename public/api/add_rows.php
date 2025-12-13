<?php
// public/api/add_rows.php - versão corrigida: monta INSERT por linha apenas com colunas fornecidas
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/db.php';

$raw = file_get_contents('php://input');
$payload = json_decode($raw, true);

if (!is_array($payload) || empty($payload['table']) || !isset($payload['data'])) {
    http_response_code(400);
    echo json_encode(['error' => 'payload inválido']);
    exit;
}

$table = $payload['table'];
if (!preg_match('/^[a-z0-9_\-]+$/i', $table)) {
    http_response_code(400);
    echo json_encode(['error' => 'nome de tabela inválido']);
    exit;
}

$newRows = $payload['data'];
if (!is_array($newRows)) {
    http_response_code(400);
    echo json_encode(['error' => "o campo 'data' deve ser um array"]);
    exit;
}

// Verifica existência da tabela
$res = $mysqli->query("SHOW TABLES LIKE '" . $mysqli->real_escape_string($table) . "'");
if (!$res || $res->num_rows === 0) {
    http_response_code(400);
    echo json_encode(['error' => 'tabela não encontrada']);
    exit;
}

// Obter metadados das colunas (campo, Null, Default, Extra)
$cols_meta = [];
$colRes = $mysqli->query("SHOW COLUMNS FROM `" . $mysqli->real_escape_string($table) . "`");
if (!$colRes) {
    http_response_code(500);
    echo json_encode(['error' => 'erro ao obter colunas', 'detail' => $mysqli->error]);
    exit;
}
while ($c = $colRes->fetch_assoc()) {
    // guardar meta por nome
    $cols_meta[$c['Field']] = $c;
}
// lista de colunas ordenada (exc auto_increment)
$cols_order = [];
foreach ($cols_meta as $fname => $meta) {
    if (isset($meta['Extra']) && stripos($meta['Extra'], 'auto_increment') !== false) continue;
    $cols_order[] = $fname;
}
if (count($cols_order) === 0) {
    http_response_code(500);
    echo json_encode(['error' => 'nenhuma coluna para inserir']);
    exit;
}

// helpers
function is_assoc($arr) {
    if (!is_array($arr)) return false;
    return array_keys($arr) !== range(0, count($arr) - 1);
}
function bind_params_dynamic($stmt, $types, $values) {
    $refs = [];
    $refs[] = $types;
    foreach ($values as $k => $v) $refs[] = &$values[$k];
    return call_user_func_array([$stmt, 'bind_param'], $refs);
}

$inserted = 0;
$mysqli->begin_transaction();

try {
    foreach ($newRows as $row) {
        // determinar colunas e valores desta linha
        $insert_cols = [];
        $values = [];

        if (is_assoc($row)) {
            // incluir apenas colunas presentes no objecto associativo e que existem na tabela
            foreach ($row as $k => $v) {
                if (array_key_exists($k, $cols_meta)) {
                    // skip auto_increment explicitly (already not in cols_meta list for insert)
                    $insert_cols[] = $k;
                    $values[] = $v;
                }
            }
        } else {
            // positional array: considerar somente os índices definidos
            for ($i = 0; $i < count($cols_order); $i++) {
                if (array_key_exists($i, $row)) { // index exists in the provided array
                    $insert_cols[] = $cols_order[$i];
                    $values[] = $row[$i];
                }
                // if not provided, skip column so DB default applies
            }
        }

        if (count($insert_cols) === 0) {
            // nada a inserir nesta linha
            continue;
        }

        // montar SQL só com colunas desta linha
        $colList = implode('`,`', array_map(function($c){ return $c; }, $insert_cols));
        $placeholders = implode(',', array_fill(0, count($values), '?'));
        $sql = "INSERT INTO `" . $mysqli->real_escape_string($table) . "` (`$colList`) VALUES ($placeholders)";

        $stmt = $mysqli->prepare($sql);
        if (!$stmt) {
            throw new Exception('Erro ao preparar statement: ' . $mysqli->error);
        }

        // todos os parametros como strings por simplicidade (podes mapear por tipo se quiseres)
        $types = str_repeat('s', count($values));
        if (!bind_params_dynamic($stmt, $types, $values)) {
            throw new Exception('Erro no bind_param: ' . json_encode($values));
        }

        if (!$stmt->execute()) {
            throw new Exception('Erro ao inserir: ' . $stmt->error);
        }

        $inserted++;
        $stmt->close();
    }

    $mysqli->commit();
    echo json_encode(['inserted' => $inserted]);
} catch (Exception $e) {
    $mysqli->rollback();
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
    exit;
}

