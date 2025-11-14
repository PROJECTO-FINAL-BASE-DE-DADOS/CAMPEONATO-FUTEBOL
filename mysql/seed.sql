-- seed.sql (exemplos)
USE `campeonato`;

INSERT INTO equipa (nome, cidade, estadio) VALUES
('Atlético FC', 'Maputo', 'Estádio Nacional'),
('Benfica Local', 'Beira', 'Estádio Municipal'),
('Sporting Cidade', 'Nampula', 'Estádio Central');

INSERT INTO arbitro (nome, categoria, nacionalidade) VALUES
('João Silva', 'Nacional', 'Moçambique'),
('Carlos Mendes', 'Internacional', 'Portugal');

INSERT INTO treinador (nome, nacionalidade, equipa_id) VALUES
('Miguel Pereira', 'Moçambique', 1),
('Rui Costa', 'Portugal', 2);

INSERT INTO capitao (nome, equipa_id, posicao, numero) VALUES
('André Matias', 1, 'Defesa', 4),
('Pedro Santos', 2, 'Médio', 8);

INSERT INTO jogo (equipa_casa_id, equipa_fora_id, data_hora, estadio, arbitro_id, golo_casa, golo_fora, rodada) VALUES
(1,2,'2025-11-20 15:00:00','Estádio Nacional',1,2,1,1),
(2,3,'2025-11-22 18:00:00','Estádio Municipal',2,0,0,1);

INSERT INTO resumo (jogo_id, resumo_text, espectadores) VALUES
(1,'Atlético FC venceu 2-1 num jogo competitivo.',12000),
(2,'Jogo sem golos, domínio defensivo.',5000);
