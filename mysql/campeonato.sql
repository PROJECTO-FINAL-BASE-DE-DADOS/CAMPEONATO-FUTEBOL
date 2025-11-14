-- create_tables.sql
-- Schema suggested for Campeonato de Futebol (MySQL)
CREATE DATABASE IF NOT EXISTS `campeonato` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `campeonato`;

-- Teams
CREATE TABLE IF NOT EXISTS `equipa` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `cidade` VARCHAR(100) DEFAULT NULL,
  `estadio` VARCHAR(150) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_equipa_nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Coaches
CREATE TABLE IF NOT EXISTS `treinador` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `nacionalidade` VARCHAR(80) DEFAULT NULL,
  `equipa_id` INT UNSIGNED DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_treinador_equipa` (`equipa_id`),
  CONSTRAINT `fk_treinador_equipa` FOREIGN KEY (`equipa_id`) REFERENCES `equipa`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Captains (could be players; simplified)
CREATE TABLE IF NOT EXISTS `capitao` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `equipa_id` INT UNSIGNED NOT NULL,
  `posicao` VARCHAR(60) DEFAULT NULL,
  `numero` SMALLINT UNSIGNED DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_capitao_equipa` (`equipa_id`),
  CONSTRAINT `fk_capitao_equipa` FOREIGN KEY (`equipa_id`) REFERENCES `equipa`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Referees
CREATE TABLE IF NOT EXISTS `arbitro` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `categoria` VARCHAR(80) DEFAULT NULL,
  `nacionalidade` VARCHAR(80) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Matches
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
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_jogo_casa` (`equipa_casa_id`),
  KEY `idx_jogo_fora` (`equipa_fora_id`),
  KEY `idx_jogo_arbitro` (`arbitro_id`),
  CONSTRAINT `fk_jogo_casa` FOREIGN KEY (`equipa_casa_id`) REFERENCES `equipa`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_jogo_fora` FOREIGN KEY (`equipa_fora_id`) REFERENCES `equipa`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_jogo_arbitro` FOREIGN KEY (`arbitro_id`) REFERENCES `arbitro`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Match summary
CREATE TABLE IF NOT EXISTS `resumo` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `jogo_id` INT UNSIGNED NOT NULL,
  `resumo_text` TEXT,
  `espectadores` INT UNSIGNED DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_resumo_jogo` (`jogo_id`),
  CONSTRAINT `fk_resumo_jogo` FOREIGN KEY (`jogo_id`) REFERENCES `jogo`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
