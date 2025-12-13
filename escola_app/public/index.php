<?php require_once __DIR__ . "/../utils/helpers.php"; ?>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Escola App</title>
  <style>
    body{font-family:Arial, sans-serif; margin:20px;}
    nav a{margin-right:12px;}
    .card{border:1px solid #ddd; padding:14px; border-radius:8px; margin-top:12px;}
  </style>
</head>
<body>
  <h1>Escola App (PHP + MySQL)</h1>

  <nav>
    <a href="alunos.php">Alunos</a>
    <a href="professores.php">Professores</a>
    <a href="disciplinas.php">Disciplinas</a>
    <a href="matriculas.php">Matrículas</a>
    <a href="pesquisar.php">Pesquisar</a>
  </nav>

  <div class="card">
    <h3>Regras</h3>
    <ul>
      <li>Disciplina pertence a um Professor.</li>
      <li>Matrícula liga Aluno e Disciplina.</li>
      <li>Regra “Aluno deve matricular em pelo menos 1 disciplina” é garantida pela aplicação (ao criar aluno, matricule-o logo em seguida).</li>
    </ul>
  </div>
</body>
</html>
