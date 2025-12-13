<?php
require_once __DIR__ . "/../config/db.php";
require_once __DIR__ . "/../utils/helpers.php";

$erro = "";
$ok = "";

/**
 * DELETE (POST) - pode falhar se existir disciplina associada (FK RESTRICT)
 */
if ($_SERVER["REQUEST_METHOD"] === "POST" && ($_POST["action"] ?? "") === "delete") {
    if (!csrf_validate($_POST["csrf"] ?? null)) {
        http_response_code(403);
        die("CSRF inválido.");
    }

    $id = (int)($_POST["id"] ?? 0);
    if ($id > 0) {
        try {
            $stmt = $conn->prepare("DELETE FROM professor WHERE id=?");
            $stmt->bind_param("i", $id);
            $stmt->execute();
            $ok = "Professor removido com sucesso.";
        } catch (mysqli_sql_exception $e) {
            $erro = "Erro ao remover professor (verifique se ele tem disciplinas): " . $e->getMessage();
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
    $email = trim($_POST["email"] ?? "");

    if ($nome === "") {
        $erro = "Nome do professor é obrigatório.";
    } else {
        try {
            $stmt = $conn->prepare("INSERT INTO professor (nome, email) VALUES (?, ?)");
            $emailParam = ($email === "") ? null : $email;
            if ($emailParam === null) $emailParam = "";
            $stmt->bind_param("ss", $nome, $emailParam);
            $stmt->execute();

            if ($email === "") {
                $newId = $conn->insert_id;
                $stmt2 = $conn->prepare("UPDATE professor SET email=NULL WHERE id=?");
                $stmt2->bind_param("i", $newId);
                $stmt2->execute();
            }

            redirect("professores.php");
        } catch (mysqli_sql_exception $e) {
            $erro = "Erro ao salvar professor: " . $e->getMessage();
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
    $email = trim($_POST["email"] ?? "");

    if ($id <= 0 || $nome === "") {
        $erro = "Dados inválidos para atualização.";
    } else {
        try {
            $stmt = $conn->prepare("UPDATE professor SET nome=?, email=? WHERE id=?");
            $emailParam = ($email === "") ? null : $email;
            if ($emailParam === null) $emailParam = "";
            $stmt->bind_param("ssi", $nome, $emailParam, $id);
            $stmt->execute();

            if ($email === "") {
                $stmt2 = $conn->prepare("UPDATE professor SET email=NULL WHERE id=?");
                $stmt2->bind_param("i", $id);
                $stmt2->execute();
            }

            redirect("professores.php");
        } catch (mysqli_sql_exception $e) {
            $erro = "Erro ao atualizar professor: " . $e->getMessage();
        }
    }
}

// EDIT MODE
$edit_id = (int)($_GET["edit_id"] ?? 0);
$editRow = null;
if ($edit_id > 0) {
    $stmt = $conn->prepare("SELECT id, nome, email FROM professor WHERE id=?");
    $stmt->bind_param("i", $edit_id);
    $stmt->execute();
    $editRow = $stmt->get_result()->fetch_assoc();
}

$result = $conn->query("SELECT id, nome, email, created_at FROM professor ORDER BY id DESC");
?>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="utf-8" />
  <title>Professores</title>
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
  <h2>Professores</h2>

  <?php if ($erro): ?><p class="erro"><?= h($erro) ?></p><?php endif; ?>
  <?php if ($ok): ?><p class="ok"><?= h($ok) ?></p><?php endif; ?>

  <?php if ($editRow): ?>
    <div class="card">
      <h3>Editar professor #<?= (int)$editRow["id"] ?></h3>
      <form method="post">
        <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="<?= (int)$editRow["id"] ?>">

        <label>Nome:</label><br>
        <input type="text" name="nome" required style="width:320px;" value="<?= h($editRow["nome"]) ?>"><br><br>

        <label>Email (opcional):</label><br>
        <input type="email" name="email" style="width:320px;" value="<?= h((string)($editRow["email"] ?? "")) ?>"><br><br>

        <button type="submit">Atualizar</button>
        <a href="professores.php">Cancelar</a>
      </form>
    </div>
  <?php else: ?>
    <div class="card">
      <h3>Adicionar professor</h3>
      <form method="post">
        <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
        <input type="hidden" name="action" value="create">

        <label>Nome:</label><br>
        <input type="text" name="nome" required style="width:320px;"><br><br>

        <label>Email (opcional):</label><br>
        <input type="email" name="email" style="width:320px;"><br><br>

        <button type="submit">Salvar</button>
      </form>
    </div>
  <?php endif; ?>

  <h3>Lista</h3>
  <table>
    <thead>
      <tr><th>ID</th><th>Nome</th><th>Email</th><th>Criado em</th><th>Ações</th></tr>
    </thead>
    <tbody>
      <?php while ($row = $result->fetch_assoc()): ?>
        <tr>
          <td><?= (int)$row["id"] ?></td>
          <td><?= h($row["nome"]) ?></td>
          <td><?= h((string)($row["email"] ?? "")) ?></td>
          <td><?= h($row["created_at"]) ?></td>
          <td>
            <a href="professores.php?edit_id=<?= (int)$row["id"] ?>">Editar</a>

            <form method="post" style="display:inline" onsubmit="return confirm('Remover este professor? Só será possível se ele NÃO tiver disciplinas.');">
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
