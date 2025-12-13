-- campeonato.sql - versão corrigida para MySQL 8 Ubuntu
-- Sem CHECK problemático
-- Sem CREATE INDEX IF NOT EXISTS

CREATE DATABASE IF NOT EXISTS `campeonato`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `campeonato`;

-- ============================
-- TABELA: equipa
-- ============================
CREATE TABLE IF NOT EXISTS `equipa` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `sigla` VARCHAR(8) DEFAULT NULL,
  `cidade` VARCHAR(100) DEFAULT NULL,
  `estadio` VARCHAR(150) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_equipa_nome` (`nome`),
  UNIQUE KEY `uq_equipa_sigla` (`sigla`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- TABELA: treinador
-- ============================
CREATE TABLE IF NOT EXISTS `treinador` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `nacionalidade` VARCHAR(80) DEFAULT NULL,
  `equipa_id` INT UNSIGNED DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`id`),
  INDEX `idx_treinador_equipa` (`equipa_id`),
  CONSTRAINT `fk_treinador_equipa` FOREIGN KEY (`equipa_id`)
    REFERENCES `equipa`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- TABELA: jogador
-- ============================
CREATE TABLE IF NOT EXISTS `jogador` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `data_nascimento` DATE DEFAULT NULL,
  `nacionalidade` VARCHAR(80) DEFAULT NULL,
  `posicao` VARCHAR(30) DEFAULT NULL,
  `numero` SMALLINT UNSIGNED DEFAULT NULL,
  `equipa_id` INT UNSIGNED DEFAULT NULL,
  `capitao` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`id`),
  INDEX `idx_jogador_equipa` (`equipa_id`),
  CONSTRAINT `fk_jogador_equipa` FOREIGN KEY (`equipa_id`)
    REFERENCES `equipa`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- TABELA: arbitro
-- ============================
CREATE TABLE IF NOT EXISTS `arbitro` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `categoria` VARCHAR(80) DEFAULT NULL,
  `nacionalidade` VARCHAR(80) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- TABELA: jogo
-- ============================
CREATE TABLE IF NOT EXISTS `jogo` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `equipa_casa_id` INT UNSIGNED NOT NULL,
  `equipa_fora_id` INT UNSIGNED NOT NULL,
  `data_hora` DATETIME NOT NULL,
  `estadio` VARCHAR(150) DEFAULT NULL,
  `arbitro_id` INT UNSIGNED DEFAULT NULL,
  `golo_casa` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `golo_fora` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `rodada` SMALLINT UNSIGNED DEFAULT NULL,
  `observacoes` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`id`),
  INDEX `idx_jogo_casa` (`equipa_casa_id`),
  INDEX `idx_jogo_fora` (`equipa_fora_id`),
  INDEX `idx_jogo_data` (`data_hora`),
  INDEX `idx_jogo_rodada` (`rodada`),

  CONSTRAINT `fk_jogo_casa` FOREIGN KEY (`equipa_casa_id`)
    REFERENCES `equipa`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,

  CONSTRAINT `fk_jogo_fora` FOREIGN KEY (`equipa_fora_id`)
    REFERENCES `equipa`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,

  CONSTRAINT `fk_jogo_arbitro` FOREIGN KEY (`arbitro_id`)
    REFERENCES `arbitro`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- TABELA: substituicao
-- ============================
CREATE TABLE IF NOT EXISTS `substituicao` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `jogo_id` INT UNSIGNED NOT NULL,
  `jogador_entrada_id` INT UNSIGNED NOT NULL,
  `jogador_saida_id` INT UNSIGNED DEFAULT NULL,
  `minuto` SMALLINT UNSIGNED DEFAULT NULL,
  `equipa_id` INT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (`id`),
  INDEX `idx_sub_jogo` (`jogo_id`),

  CONSTRAINT `fk_sub_jogo` FOREIGN KEY (`jogo_id`)
    REFERENCES `jogo`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,

  CONSTRAINT `fk_sub_entrada` FOREIGN KEY (`jogador_entrada_id`)
    REFERENCES `jogador`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,

  CONSTRAINT `fk_sub_saida` FOREIGN KEY (`jogador_saida_id`)
    REFERENCES `jogador`(`id`) ON DELETE SET NULL ON UPDATE CASCADE,

  CONSTRAINT `fk_sub_equipa` FOREIGN KEY (`equipa_id`)
    REFERENCES `equipa`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- TABELA: evento
-- ============================
CREATE TABLE IF NOT EXISTS `evento` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `jogo_id` INT UNSIGNED NOT NULL,
  `tipo` VARCHAR(40) NOT NULL,
  `jogador_id` INT UNSIGNED DEFAULT NULL,
  `minuto` SMALLINT UNSIGNED DEFAULT NULL,
  `detalhe` VARCHAR(200) DEFAULT NULL,
  `criador` VARCHAR(100) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (`id`),
  INDEX `idx_evento_jogo` (`jogo_id`),

  CONSTRAINT `fk_evento_jogo` FOREIGN KEY (`jogo_id`)
    REFERENCES `jogo`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,

  CONSTRAINT `fk_evento_jogador` FOREIGN KEY (`jogador_id`)
    REFERENCES `jogador`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- TABELA: resumo
-- ============================
CREATE TABLE IF NOT EXISTS `resumo` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `jogo_id` INT UNSIGNED NOT NULL,
  `resumo_text` TEXT DEFAULT NULL,
  `espectadores` INT UNSIGNED DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (`id`),
  INDEX `idx_resumo_jogo` (`jogo_id`),

  CONSTRAINT `fk_resumo_jogo` FOREIGN KEY (`jogo_id`)
    REFERENCES `jogo`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- VIEW v_jogos_ultimos
-- ============================
DROP VIEW IF EXISTS `v_jogos_ultimos`;
CREATE VIEW `v_jogos_ultimos` AS
SELECT j.id, j.data_hora, c.nome AS casa, f.nome AS fora,
       j.golo_casa, j.golo_fora, j.rodada
FROM `jogo` j
JOIN `equipa` c ON j.equipa_casa_id = c.id
JOIN `equipa` f ON j.equipa_fora_id = f.id
ORDER BY j.data_hora DESC;

-- Índices adicionais
CREATE INDEX `idx_jogador_nome` ON `jogador` (`nome`);
CREATE INDEX `idx_equipa_nome` ON `equipa` (`nome`);
CREATE INDEX `idx_arbitro_nome` ON `arbitro` (`nome`);
