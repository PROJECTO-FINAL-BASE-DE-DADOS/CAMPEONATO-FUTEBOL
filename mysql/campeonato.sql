-- create_tables.sql
-- Schema completo para Campeonato de Futebol (MySQL)
-- Normalizado até 3FN conforme requisitos do projeto

CREATE DATABASE IF NOT EXISTS `campeonato` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `campeonato`;

-- Tabela: Equipa (Times)
CREATE TABLE IF NOT EXISTS `equipa` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `cidade` VARCHAR(100) DEFAULT NULL,
  `estadio` VARCHAR(150) DEFAULT NULL,
  `ano_fundacao` YEAR DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_equipa_nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Tabela de equipas/times participantes';

-- Tabela: Treinador (Coaches)
CREATE TABLE IF NOT EXISTS `treinador` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `nacionalidade` VARCHAR(80) DEFAULT NULL,
  `data_nascimento` DATE DEFAULT NULL,
  `equipa_id` INT UNSIGNED DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_treinador_equipa` (`equipa_id`),
  CONSTRAINT `fk_treinador_equipa` FOREIGN KEY (`equipa_id`) 
    REFERENCES `equipa`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Tabela de treinadores';

-- Tabela: Jogador (Players)
CREATE TABLE IF NOT EXISTS `jogador` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `equipa_id` INT UNSIGNED NOT NULL,
  `posicao` VARCHAR(60) DEFAULT NULL,
  `numero` SMALLINT UNSIGNED DEFAULT NULL,
  `data_nascimento` DATE DEFAULT NULL,
  `nacionalidade` VARCHAR(80) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_jogador_equipa` (`equipa_id`),
  KEY `idx_jogador_posicao` (`posicao`),
  CONSTRAINT `fk_jogador_equipa` FOREIGN KEY (`equipa_id`) 
    REFERENCES `equipa`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Tabela de jogadores';

-- Tabela: Capitao (Captains) - Relacionamento com Jogador
CREATE TABLE IF NOT EXISTS `capitao` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `jogador_id` INT UNSIGNED NOT NULL,
  `equipa_id` INT UNSIGNED NOT NULL,
  `data_inicio` DATE NOT NULL,
  `data_fim` DATE DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_capitao_jogador_ativo` (`jogador_id`, `equipa_id`, `data_fim`),
  KEY `idx_capitao_equipa` (`equipa_id`),
  CONSTRAINT `fk_capitao_jogador` FOREIGN KEY (`jogador_id`) 
    REFERENCES `jogador`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_capitao_equipa` FOREIGN KEY (`equipa_id`) 
    REFERENCES `equipa`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Tabela de capitães (histórico)';

-- Tabela: Arbitro (Referees)
CREATE TABLE IF NOT EXISTS `arbitro` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `categoria` VARCHAR(80) DEFAULT NULL,
  `nacionalidade` VARCHAR(80) DEFAULT NULL,
  `data_nascimento` DATE DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_arbitro_categoria` (`categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Tabela de árbitros';

-- Tabela: Jogo (Matches)
CREATE TABLE IF NOT EXISTS `jogo` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `equipa_casa_id` INT UNSIGNED NOT NULL,
  `equipa_fora_id` INT UNSIGNED NOT NULL,
  `data_hora` DATETIME NOT NULL,
  `estadio` VARCHAR(150) DEFAULT NULL,
  `arbitro_id` INT UNSIGNED DEFAULT NULL,
  `golo_casa` TINYINT UNSIGNED DEFAULT 0,
  `golo_fora` TINYINT UNSIGNED DEFAULT 0,
  `rodada` SMALLINT UNSIGNED DEFAULT NULL,
  `status` ENUM('agendado', 'em_andamento', 'finalizado', 'cancelado') DEFAULT 'agendado',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_jogo_casa` (`equipa_casa_id`),
  KEY `idx_jogo_fora` (`equipa_fora_id`),
  KEY `idx_jogo_arbitro` (`arbitro_id`),
  KEY `idx_jogo_data` (`data_hora`),
  KEY `idx_jogo_rodada` (`rodada`),
  CONSTRAINT `fk_jogo_casa` FOREIGN KEY (`equipa_casa_id`) 
    REFERENCES `equipa`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_jogo_fora` FOREIGN KEY (`equipa_fora_id`) 
    REFERENCES `equipa`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_jogo_arbitro` FOREIGN KEY (`arbitro_id`) 
    REFERENCES `arbitro`(`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_jogo_equipas_diferentes` CHECK (`equipa_casa_id` <> `equipa_fora_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Tabela de jogos/partidas';

-- Tabela: Resumo (Match Summary)
CREATE TABLE IF NOT EXISTS `resumo` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `jogo_id` INT UNSIGNED NOT NULL,
  `resumo_text` TEXT,
  `espectadores` INT UNSIGNED DEFAULT NULL,
  `temperatura` DECIMAL(4,1) DEFAULT NULL,
  `condicao_clima` VARCHAR(50) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_resumo_jogo` (`jogo_id`),
  CONSTRAINT `fk_resumo_jogo` FOREIGN KEY (`jogo_id`) 
    REFERENCES `jogo`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Tabela de resumos de jogos';

-- Tabela: Estatistica_Jogador (Player Statistics per Match)
CREATE TABLE IF NOT EXISTS `estatistica_jogador` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `jogo_id` INT UNSIGNED NOT NULL,
  `jogador_id` INT UNSIGNED NOT NULL,
  `gols` TINYINT UNSIGNED DEFAULT 0,
  `assistencias` TINYINT UNSIGNED DEFAULT 0,
  `cartao_amarelo` TINYINT UNSIGNED DEFAULT 0,
  `cartao_vermelho` TINYINT UNSIGNED DEFAULT 0,
  `minutos_jogados` SMALLINT UNSIGNED DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_estat_jogo_jogador` (`jogo_id`, `jogador_id`),
  KEY `idx_estat_jogador` (`jogador_id`),
  CONSTRAINT `fk_estat_jogo` FOREIGN KEY (`jogo_id`) 
    REFERENCES `jogo`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_estat_jogador` FOREIGN KEY (`jogador_id`) 
    REFERENCES `jogador`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Estatísticas de jogadores por partida';

-- Views úteis para relatórios

-- View: Classificação das equipas
CREATE OR REPLACE VIEW vw_classificacao AS
SELECT 
  e.id,
  e.nome AS equipa,
  COUNT(j.id) AS jogos,
  SUM(CASE 
    WHEN (j.equipa_casa_id = e.id AND j.golo_casa > j.golo_fora) OR 
         (j.equipa_fora_id = e.id AND j.golo_fora > j.golo_casa) 
    THEN 1 ELSE 0 END) AS vitorias,
  SUM(CASE WHEN j.golo_casa = j.golo_fora THEN 1 ELSE 0 END) AS empates,
  SUM(CASE 
    WHEN (j.equipa_casa_id = e.id AND j.golo_casa < j.golo_fora) OR 
         (j.equipa_fora_id = e.id AND j.golo_fora < j.golo_casa) 
    THEN 1 ELSE 0 END) AS derrotas,
  SUM(CASE 
    WHEN j.equipa_casa_id = e.id THEN j.golo_casa 
    ELSE j.golo_fora END) AS gols_marcados,
  SUM(CASE 
    WHEN j.equipa_casa_id = e.id THEN j.golo_fora 
    ELSE j.golo_casa END) AS gols_sofridos,
  (SUM(CASE 
    WHEN j.equipa_casa_id = e.id THEN j.golo_casa 
    ELSE j.golo_fora END) - 
   SUM(CASE 
    WHEN j.equipa_casa_id = e.id THEN j.golo_fora 
    ELSE j.golo_casa END)) AS saldo_gols,
  (SUM(CASE 
    WHEN (j.equipa_casa_id = e.id AND j.golo_casa > j.golo_fora) OR 
         (j.equipa_fora_id = e.id AND j.golo_fora > j.golo_casa) 
    THEN 3 ELSE 0 END) +
   SUM(CASE WHEN j.golo_casa = j.golo_fora THEN 1 ELSE 0 END)) AS pontos
FROM equipa e
LEFT JOIN jogo j ON (j.equipa_casa_id = e.id OR j.equipa_fora_id = e.id) 
  AND j.status = 'finalizado'
GROUP BY e.id, e.nome
ORDER BY pontos DESC, saldo_gols DESC, gols_marcados DESC;

-- View: Artilheiros
CREATE OR REPLACE VIEW vw_artilheiros AS
SELECT 
  jog.id,
  jog.nome AS jogador,
  e.nome AS equipa,
  SUM(est.gols) AS total_gols,
  COUNT(DISTINCT est.jogo_id) AS jogos
FROM jogador jog
JOIN equipa e ON jog.equipa_id = e.id
JOIN estatistica_jogador est ON jog.id = est.jogador_id
GROUP BY jog.id, jog.nome, e.nome
HAVING total_gols > 0
ORDER BY total_gols DESC, jogos ASC;

-- View: Próximos jogos
CREATE OR REPLACE VIEW vw_proximos_jogos AS
SELECT 
  j.id,
  j.data_hora,
  ec.nome AS equipa_casa,
  ef.nome AS equipa_fora,
  j.estadio,
  a.nome AS arbitro,
  j.rodada,
  j.status
FROM jogo j
JOIN equipa ec ON j.equipa_casa_id = ec.id
JOIN equipa ef ON j.equipa_fora_id = ef.id
LEFT JOIN arbitro a ON j.arbitro_id = a.id
WHERE j.status IN ('agendado', 'em_andamento')
ORDER BY j.data_hora ASC;