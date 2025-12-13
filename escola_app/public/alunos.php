<?php
require_once __DIR__ . "/../config/db.php";
require_once __DIR__ . "/../utils/helpers.php";

$erro = "";
$ok = "";

/**
 * DELETE (POST)
 */
if ($_SERVER["REQUEST_METHOD"] === "POST" && ($_POST["action"] ?? "") === "delete") {
    if (!csrf_validate($_POST["csrf"] ?? null)) {
        http_response_code(403);
        die("CSRF inválido.");
    }

    $id = (int)($_POST["id"] ?? 0);
    if ($id > 0) {
        try {
            $stmt = $conn->prepare("DELETE FROM aluno WHERE id=?");
            $stmt->bind_param("i", $id);
            $stmt->execute();
            $ok = "Aluno removido com sucesso.";
        } catch (mysqli_sql_exception $e) {
            $erro = "Erro ao remover aluno: " . $e->getMessage();
        }
    }
}

/**
 * CREATE (POST)
 */
if ($_SERVER["REQUEST_METHOD"] === "POST" && ($_POST["action"] ?? "") === "create") {
    if (!csrf_validate($_POST["csrf"] ?? null)) {
        http_response_code(403);
        die("CSRF inválido.");
    }

    $nome = trim($_POST["nome"] ?? "");
    $email = trim($_POST["email"] ?? "");

    if ($nome === "") {
        $erro = "Nome do aluno é obrigatório.";
    } else {
        try {
            $stmt = $conn->prepare("INSERT INTO aluno (nome, email) VALUES (?, ?)");
            $emailParam = ($email === "") ? null : $email;
            // bind_param não aceita null com "s" de forma perfeita em todas versões;
            // solução simples: passar string vazia e deixar a coluna aceitar NULL? Aqui mantemos como string.
            if ($emailParam === null) $emailParam = "";
            $stmt->bind_param("ss", $nome, $emailParam);
            $stmt->execute();

            // se email veio vazio, corrigir para NULL (opcional, mas mantém consistência)
            if ($email === "") {
                $newId = $conn->insert_id;
                $stmt2 = $conn->prepare("UPDATE aluno SET email=NULL WHERE id=?");
                $stmt2->bind_param("i", $newId);
                $stmt2->execute();
            }

            redirect("alunos.php");
        } catch (mysqli_sql_exception $e) {
            $erro = "Erro ao salvar aluno: " . $e->getMessage();
        }
    }
}

/**
 * UPDATE (POST)
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
            $stmt = $conn->prepare("UPDATE aluno SET nome=?, email=? WHERE id=?");
            $emailParam = ($email === "") ? null : $email;
            if ($emailParam === null) $emailParam = "";
            $stmt->bind_param("ssi", $nome, $emailParam, $id);
            $stmt->execute();

            if ($email === "") {
                $stmt2 = $conn->prepare("UPDATE aluno SET email=NULL WHERE id=?");
                $stmt2->bind_param("i", $id);
                $stmt2->execute();
            }

            redirect("alunos.php");
        } catch (mysqli_sql_exception $e) {
            $erro = "Erro ao atualizar aluno: " . $e->getMessage();
        }
    }
}

// EDIT MODE (GET)
$edit_id = (int)($_GET["edit_id"] ?? 0);
$editRow = null;
if ($edit_id > 0) {
    $stmt = $conn->prepare("SELECT id, nome, email FROM aluno WHERE id=?");
    $stmt->bind_param("i", $edit_id);
    $stmt->execute();
    $editRow = $stmt->get_result()->fetch_assoc();
}

$result = $conn->query("SELECT id, nome, email, created_at FROM aluno ORDER BY id DESC");
?>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="utf-8" />
  <title>Alunos</title>
  <style>
    body{font-family:Arial;margin:20px}
    table{border-collapse:collapse;width:100%}
    th,td{border:1px solid #ddd;padding:8px}
    nav a{margin-right:12px}
    .erro{color:#b00}
    .ok{color:#080}
    .actions a{margin-right:10px}
    .card{border:1px solid #ddd;padding:12px;border-radius:8px;margin:12px 0}
  </style>
</head>
<body>
  <nav><a href="index.php">Início</a> <a href="pesquisar.php">Pesquisar</a></nav>
  <h2>Alunos</h2>

  <?php if ($erro): ?><p class="erro"><?= h($erro) ?></p><?php endif; ?>
  <?php if ($ok): ?><p class="ok"><?= h($ok) ?></p><?php endif; ?>

  <?php if ($editRow): ?>
    <div class="card">
      <h3>Editar aluno #<?= (int)$editRow["id"] ?></h3>
      <form method="post">
        <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="<?= (int)$editRow["id"] ?>">

        <label>Nome:</label><br>
        <input type="text" name="nome" required style="width:320px;" value="<?= h($editRow["nome"]) ?>"><br><br>

        <label>Email (opcional):</label><br>
        <input type="email" name="email" style="width:320px;" value="<?= h((string)($editRow["email"] ?? "")) ?>"><br><br>

        <button type="submit">Atualizar</button>
        <a href="alunos.php">Cancelar</a>
      </form>
    </div>
  <?php else: ?>
    <div class="card">
      <h3>Adicionar aluno</h3>
      <form method="post">
        <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
        <input type="hidden" name="action" value="create">

        <label>Nome:</label><br>
        <input type="text" name="nome" required style="width:320px;"><br><br>

        <label>Email (opcional):</label><br>
        <input type="email" name="email" style="width:320px;"><br><br>

        <button type="submit">Salvar</button>
      </form>
      <p><strong>Nota:</strong> Depois de criar o aluno, vá em <a href="matriculas.php">Matrículas</a> para matricular em pelo menos 1 disciplina.</p>
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
          <td class="actions">
            <a href="alunos.php?edit_id=<?= (int)$row["id"] ?>">Editar</a>
            <form method="post" style="display:inline" onsubmit="return confirm('Remover este aluno? Isso removerá também as matrículas dele.');">
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
