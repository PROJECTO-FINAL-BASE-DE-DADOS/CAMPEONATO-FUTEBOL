<?php
require_once __DIR__ . "/../config/db.php";
require_once __DIR__ . "/../utils/helpers.php";

$erro = "";
$ok = "";

/**
 * DELETE (POST) - pode falhar se existir matrícula associada (FK RESTRICT)
 */
if ($_SERVER["REQUEST_METHOD"] === "POST" && ($_POST["action"] ?? "") === "delete") {
    if (!csrf_validate($_POST["csrf"] ?? null)) {
        http_response_code(403);
        die("CSRF inválido.");
    }

    $id = (int)($_POST["id"] ?? 0);
    if ($id > 0) {
        try {
            $stmt = $conn->prepare("DELETE FROM disciplina WHERE id=?");
            $stmt->bind_param("i", $id);
            $stmt->execute();
            $ok = "Disciplina removida com sucesso.";
        } catch (mysqli_sql_exception $e) {
            $erro = "Erro ao remover disciplina (verifique se tem matrículas): " . $e->getMessage();
        }
    }
}

/**
 * CREATE
 */
if ($_SERVER["REQUEST_METHOD"] === "POST" && ($_POST["action"] ?? "") === "create") {
    if (!csrf_validate($_POST["csrf"] ?? null)) {
        http_response_code(403);
        die("CSRF inválido.");
    }

    $nome = trim($_POST["nome"] ?? "");
    $professor_id = (int)($_POST["professor_id"] ?? 0);

    if ($nome === "" || $professor_id <= 0) {
        $erro = "Nome da disciplina e professor são obrigatórios.";
    } else {
        try {
            $stmt = $conn->prepare("INSERT INTO disciplina (nome, professor_id) VALUES (?, ?)");
            $stmt->bind_param("si", $nome, $professor_id);
            $stmt->execute();
            redirect("disciplinas.php");
        } catch (mysqli_sql_exception $e) {
            $erro = "Erro ao salvar disciplina: " . $e->getMessage();
        }
    }
}

/**
 * UPDATE
 */
if ($_SERVER["REQUEST_METHOD"] === "POST" && ($_POST["action"] ?? "") === "update") {
    if (!csrf_validate($_POST["csrf"] ?? null)) {
        http_response_code(403);
        die("CSRF inválido.");
    }

    $id = (int)($_POST["id"] ?? 0);
    $nome = trim($_POST["nome"] ?? "");
    $professor_id = (int)($_POST["professor_id"] ?? 0);

    if ($id <= 0 || $nome === "" || $professor_id <= 0) {
        $erro = "Dados inválidos para atualização.";
    } else {
        try {
            $stmt = $conn->prepare("UPDATE disciplina SET nome=?, professor_id=? WHERE id=?");
            $stmt->bind_param("sii", $nome, $professor_id, $id);
            $stmt->execute();
            redirect("disciplinas.php");
        } catch (mysqli_sql_exception $e) {
            $erro = "Erro ao atualizar disciplina: " . $e->getMessage();
        }
    }
}

// EDIT MODE
$edit_id = (int)($_GET["edit_id"] ?? 0);
$editRow = null;
if ($edit_id > 0) {
    $stmt = $conn->prepare("SELECT id, nome, professor_id FROM disciplina WHERE id=?");
    $stmt->bind_param("i", $edit_id);
    $stmt->execute();
    $editRow = $stmt->get_result()->fetch_assoc();
}

// Professores p/ dropdown
$professores = $conn->query("SELECT id, nome FROM professor ORDER BY nome ASC");

// Listar disciplinas
$sql = "SELECT d.id, d.nome AS disciplina, p.nome AS professor
        FROM disciplina d
        INNER JOIN professor p ON p.id = d.professor_id
        ORDER BY d.id DESC";
$result = $conn->query($sql);
?>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="utf-8" />
  <title>Disciplinas</title>
  <style>
    body{font-family:Arial;margin:20px}
    table{border-collapse:collapse;width:100%}
    th,td{border:1px solid #ddd;padding:8px}
    nav a{margin-right:12px}
    .erro{color:#b00}
    .ok{color:#080}
    .card{border:1px solid #ddd;padding:12px;border-radius:8px;margin:12px 0}
  </style>
</head>
<body>
  <nav><a href="index.php">Início</a> <a href="pesquisar.php">Pesquisar</a></nav>
  <h2>Disciplinas</h2>

  <?php if ($erro): ?><p class="erro"><?= h($erro) ?></p><?php endif; ?>
  <?php if ($ok): ?><p class="ok"><?= h($ok) ?></p><?php endif; ?>

  <div class="card">
    <?php if ($editRow): ?>
      <h3>Editar disciplina #<?= (int)$editRow["id"] ?></h3>
      <form method="post">
        <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="<?= (int)$editRow["id"] ?>">

        <label>Nome:</label><br>
        <input type="text" name="nome" required style="width:320px;" value="<?= h($editRow["nome"]) ?>"><br><br>

        <label>Professor:</label><br>
        <select name="professor_id" required style="width:330px;">
          <option value="">-- selecione --</option>
          <?php
            // Recarregar professores (o resultset já foi consumido em alguns PHPs, então reexecuta)
            $prof2 = $conn->query("SELECT id, nome FROM professor ORDER BY nome ASC");
            while ($p = $prof2->fetch_assoc()):
              $selected = ((int)$p["id"] === (int)$editRow["professor_id"]) ? "selected" : "";
          ?>
            <option value="<?= (int)$p["id"] ?>" <?= $selected ?>><?= h($p["nome"]) ?></option>
          <?php endwhile; ?>
        </select><br><br>

        <button type="submit">Atualizar</button>
        <a href="disciplinas.php">Cancelar</a>
      </form>
    <?php else: ?>
      <h3>Adicionar disciplina</h3>
      <form method="post">
        <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
        <input type="hidden" name="action" value="create">

        <label>Nome:</label><br>
        <input type="text" name="nome" required style="width:320px;"><br><br>

        <label>Professor:</label><br>
        <select name="professor_id" required style="width:330px;">
          <option value="">-- selecione --</option>
          <?php while ($p = $professores->fetch_assoc()): ?>
            <option value="<?= (int)$p["id"] ?>"><?= h($p["nome"]) ?></option>
          <?php endwhile; ?>
        </select><br><br>

        <button type="submit">Salvar</button>
      </form>
    <?php endif; ?>
  </div>

  <h3>Lista</h3>
  <table>
    <thead>
      <tr><th>ID</th><th>Disciplina</th><th>Professor</th><th>Ações</th></tr>
    </thead>
    <tbody>
      <?php while ($row = $result->fetch_assoc()): ?>
        <tr>
          <td><?= (int)$row["id"] ?></td>
          <td><?= h($row["disciplina"]) ?></td>
          <td><?= h($row["professor"]) ?></td>
          <td>
            <a href="disciplinas.php?edit_id=<?= (int)$row["id"] ?>">Editar</a>

            <form method="post" style="display:inline" onsubmit="return confirm('Remover esta disciplina? Só será possível se não houver matrículas associadas.');">
              <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
              <input type="hidden" name="action" value="delete">
              <input type="hidden" name="id" value="<?= (int)$row["id"] ?>">
              <button type="submit">Remover</button>
            </form>
          </td>
        </tr>
      <?php endwhile; ?>
    </tbody>
  </table>
</body>
</html>
