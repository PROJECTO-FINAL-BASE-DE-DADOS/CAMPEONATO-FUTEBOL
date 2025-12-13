<?php
require_once __DIR__ . "/../config/db.php";
require_once __DIR__ . "/../utils/helpers.php";

$termo = trim($_GET["q"] ?? "");
$tipo = $_GET["tipo"] ?? "aluno"; // aluno | professor | disciplina

$dados = [];

if ($termo !== "") {
    $like = "%" . $termo . "%";

    if ($tipo === "aluno") {
        $sql = "SELECT a.id, a.nome, d.nome AS disciplina, p.nome AS professor
                FROM aluno a
                LEFT JOIN matricula m ON m.aluno_id = a.id
                LEFT JOIN disciplina d ON d.id = m.disciplina_id
                LEFT JOIN professor p ON p.id = d.professor_id
                WHERE a.nome LIKE ?
                ORDER BY a.nome, d.nome";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $like);
        $stmt->execute();
        $res = $stmt->get_result();
        while ($row = $res->fetch_assoc()) $dados[] = $row;

    } elseif ($tipo === "professor") {
        $sql = "SELECT p.id, p.nome, d.nome AS disciplina
                FROM professor p
                LEFT JOIN disciplina d ON d.professor_id = p.id
                WHERE p.nome LIKE ?
                ORDER BY p.nome, d.nome";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $like);
        $stmt->execute();
        $res = $stmt->get_result();
        while ($row = $res->fetch_assoc()) $dados[] = $row;

    } else { // disciplina
        $sql = "SELECT d.id, d.nome AS disciplina, p.nome AS professor, a.nome AS aluno
                FROM disciplina d
                INNER JOIN professor p ON p.id = d.professor_id
                LEFT JOIN matricula m ON m.disciplina_id = d.id
                LEFT JOIN aluno a ON a.id = m.aluno_id
                WHERE d.nome LIKE ?
                ORDER BY d.nome, a.nome";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $like);
        $stmt->execute();
        $res = $stmt->get_result();
        while ($row = $res->fetch_assoc()) $dados[] = $row;
    }
}
?>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="utf-8" />
  <title>Pesquisar</title>
  <style>
    body{font-family:Arial;margin:20px}
    nav a{margin-right:12px}
    table{border-collapse:collapse;width:100%}
    th,td{border:1px solid #ddd;padding:8px}
    .warn{color:#b60}
  </style>
</head>
<body>
  <nav>
    <a href="index.php">Início</a>
    <a href="alunos.php">Alunos</a>
    <a href="professores.php">Professores</a>
    <a href="disciplinas.php">Disciplinas</a>
    <a href="matriculas.php">Matrículas</a>
  </nav>

  <h2>Pesquisar</h2>

  <form method="get">
    <label>Tipo:</label>
    <select name="tipo">
      <option value="aluno" <?= $tipo==="aluno" ? "selected" : "" ?>>Aluno</option>
      <option value="professor" <?= $tipo==="professor" ? "selected" : "" ?>>Professor</option>
      <option value="disciplina" <?= $tipo==="disciplina" ? "selected" : "" ?>>Disciplina</option>
    </select>

    <label>Nome:</label>
    <input type="text" name="q" value="<?= h($termo) ?>" required style="width:320px;">
    <button type="submit">Pesquisar</button>
  </form>

  <?php if ($termo !== ""): ?>
    <h3>Resultado</h3>

    <?php if (count($dados) === 0): ?>
      <p>Nenhum resultado encontrado.</p>
    <?php else: ?>

      <?php if ($tipo === "aluno"): ?>
        <table>
          <thead>
            <tr><th>Aluno</th><th>Disciplina</th><th>Professor</th></tr>
          </thead>
          <tbody>
            <?php $alunoSemDisciplina = false; ?>
            <?php foreach ($dados as $row): ?>
              <?php if ($row["disciplina"] === null) $alunoSemDisciplina = true; ?>
              <tr>
                <td><?= h($row["nome"]) ?></td>
                <td><?= h((string)($row["disciplina"] ?? "—")) ?></td>
                <td><?= h((string)($row["professor"] ?? "—")) ?></td>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>

        <?php if ($alunoSemDisciplina): ?>
          <p class="warn"><strong>Aviso:</strong> existe aluno sem disciplina no resultado. Matricule-o em “Matrículas”.</p>
        <?php endif; ?>

      <?php elseif ($tipo === "professor"): ?>
        <table>
          <thead>
            <tr><th>Professor</th><th>Disciplina que leciona</th></tr>
          </thead>
          <tbody>
            <?php foreach ($dados as $row): ?>
              <tr>
                <td><?= h($row["nome"]) ?></td>
                <td><?= h((string)($row["disciplina"] ?? "—")) ?></td>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>

      <?php else: ?>
        <table>
          <thead>
            <tr><th>Disciplina</th><th>Professor</th><th>Alunos Matriculados</th></tr>
          </thead>
          <tbody>
            <?php foreach ($dados as $row): ?>
              <tr>
                <td><?= h($row["disciplina"]) ?></td>
                <td><?= h($row["professor"]) ?></td>
                <td><?= h((string)($row["aluno"] ?? "—")) ?></td>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      <?php endif; ?>

    <?php endif; ?>
  <?php endif; ?>
</body>
</html>
