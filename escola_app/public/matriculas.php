<?php
require_once __DIR__ . "/../config/db.php";
require_once __DIR__ . "/../utils/helpers.php";

$erro = "";
$ok = "";

// DELETE matrícula
if ($_SERVER["REQUEST_METHOD"] === "POST" && ($_POST["action"] ?? "") === "delete") {
    if (!csrf_validate($_POST["csrf"] ?? null)) {
        http_response_code(403);
        die("CSRF inválido.");
    }

    $id = (int)($_POST["id"] ?? 0);
    if ($id > 0) {
        try {
            $stmt = $conn->prepare("DELETE FROM matricula WHERE id=?");
            $stmt->bind_param("i", $id);
            $stmt->execute();
            $ok = "Matrícula removida.";
        } catch (mysqli_sql_exception $e) {
            $erro = "Erro ao remover matrícula: " . $e->getMessage();
        }
    }
}

// Dropdowns
$alunos = $conn->query("SELECT id, nome FROM aluno ORDER BY nome ASC");
$disciplinas = $conn->query("SELECT d.id, d.nome, p.nome AS professor
                             FROM disciplina d INNER JOIN professor p ON p.id = d.professor_id
                             ORDER BY d.nome ASC");

// CREATE matrícula
if ($_SERVER["REQUEST_METHOD"] === "POST" && ($_POST["action"] ?? "") === "create") {
    if (!csrf_validate($_POST["csrf"] ?? null)) {
        http_response_code(403);
        die("CSRF inválido.");
    }

    $aluno_id = (int)($_POST["aluno_id"] ?? 0);
    $disciplina_id = (int)($_POST["disciplina_id"] ?? 0);

    if ($aluno_id <= 0 || $disciplina_id <= 0) {
        $erro = "Selecione aluno e disciplina.";
    } else {
        try {
            $stmt = $conn->prepare("INSERT INTO matricula (aluno_id, disciplina_id) VALUES (?, ?)");
            $stmt->bind_param("ii", $aluno_id, $disciplina_id);
            $stmt->execute();
            $ok = "Matrícula realizada com sucesso.";
        } catch (mysqli_sql_exception $e) {
            $erro = "Não foi possível matricular (talvez já esteja matriculado): " . $e->getMessage();
        }
    }
}

// Listar matrículas
$sql = "SELECT m.id, a.nome AS aluno, d.nome AS disciplina, p.nome AS professor, m.data_matricula
        FROM matricula m
        INNER JOIN aluno a ON a.id = m.aluno_id
        INNER JOIN disciplina d ON d.id = m.disciplina_id
        INNER JOIN professor p ON p.id = d.professor_id
        ORDER BY m.id DESC";
$result = $conn->query($sql);
?>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="utf-8" />
  <title>Matrículas</title>
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
  <h2>Matrículas</h2>

  <?php if ($erro): ?><p class="erro"><?= h($erro) ?></p><?php endif; ?>
  <?php if ($ok): ?><p class="ok"><?= h($ok) ?></p><?php endif; ?>

  <div class="card">
    <h3>Matricular aluno em disciplina</h3>
    <form method="post">
      <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
      <input type="hidden" name="action" value="create">

      <label>Aluno:</label><br>
      <select name="aluno_id" required style="width:330px;">
        <option value="">-- selecione --</option>
        <?php while ($a = $alunos->fetch_assoc()): ?>
          <option value="<?= (int)$a["id"] ?>"><?= h($a["nome"]) ?></option>
        <?php endwhile; ?>
      </select><br><br>

      <label>Disciplina:</label><br>
      <select name="disciplina_id" required style="width:330px;">
        <option value="">-- selecione --</option>
        <?php while ($d = $disciplinas->fetch_assoc()): ?>
          <option value="<?= (int)$d["id"] ?>"><?= h($d["nome"]) ?> (<?= h($d["professor"]) ?>)</option>
        <?php endwhile; ?>
      </select><br><br>

      <button type="submit">Matricular</button>
    </form>
  </div>

  <h3>Lista de Matrículas</h3>
  <table>
    <thead>
      <tr><th>ID</th><th>Aluno</th><th>Disciplina</th><th>Professor</th><th>Data</th><th>Ações</th></tr>
    </thead>
    <tbody>
      <?php while ($row = $result->fetch_assoc()): ?>
        <tr>
          <td><?= (int)$row["id"] ?></td>
          <td><?= h($row["aluno"]) ?></td>
          <td><?= h($row["disciplina"]) ?></td>
          <td><?= h($row["professor"]) ?></td>
          <td><?= h($row["data_matricula"]) ?></td>
          <td>
            <form method="post" style="display:inline" onsubmit="return confirm('Remover esta matrícula?');">
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
