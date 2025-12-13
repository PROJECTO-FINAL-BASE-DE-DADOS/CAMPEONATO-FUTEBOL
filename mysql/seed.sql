-- seed.sql - Dados de teste para o sistema de campeonato
USE `campeonato`;

-- Limpar dados existentes (ordem importante por causa das FKs)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE estatistica_jogador;
TRUNCATE TABLE resumo;
TRUNCATE TABLE jogo;
TRUNCATE TABLE capitao;
TRUNCATE TABLE jogador;
TRUNCATE TABLE treinador;
TRUNCATE TABLE arbitro;
TRUNCATE TABLE equipa;
SET FOREIGN_KEY_CHECKS = 1;

-- Inserir Equipas
INSERT INTO equipa (nome, cidade, estadio, ano_fundacao) VALUES
('Maxaquene FC', 'Maputo', 'Estádio do Maxaquene', 1920),
('Ferroviário de Maputo', 'Maputo', 'Estádio da Machava', 1924),
('Costa do Sol', 'Maputo', 'Estádio do Costa do Sol', 1955),
('UD Songo', 'Songo', 'Estádio de Songo', 1981),
('Ferroviário de Nampula', 'Nampula', 'Estádio de Nampula', 1924),
('Black Bulls', 'Maputo', 'Estádio Nacional do Zimpeto', 2009),
('Incomáti FC', 'Incomáti', 'Estádio do Incomáti', 1976),
('ENH Vilankulo', 'Vilankulo', 'Estádio de Vilankulo', 1998);

-- Inserir Treinadores
INSERT INTO treinador (nome, nacionalidade, data_nascimento, equipa_id) VALUES
('Carlos Alberto', 'Moçambique', '1975-03-15', 1),
('João Silva', 'Portugal', '1970-08-22', 2),
('Manuel Costa', 'Moçambique', '1978-11-10', 3),
('Pedro Santos', 'Brasil', '1972-05-30', 4),
('António Machado', 'Moçambique', '1980-02-18', 5),
('Ricardo Ferreira', 'Portugal', '1976-09-25', 6),
('José Mateus', 'Moçambique', '1973-12-05', 7),
('Fernando Lima', 'Brasil', '1968-07-14', 8);

-- Inserir Jogadores (8 times x 11 jogadores = 88 jogadores)
-- Maxaquene FC
INSERT INTO jogador (nome, equipa_id, posicao, numero, data_nascimento, nacionalidade) VALUES
('Ernan Siluane', 1, 'Guarda-Redes', 1, '1995-01-10', 'Moçambique'),
('Domingos Macandza', 1, 'Defesa', 2, '1997-03-22', 'Moçambique'),
('Elias Pelembe', 1, 'Defesa', 3, '1996-07-15', 'Moçambique'),
('Clésio Bauque', 1, 'Defesa', 4, '1994-11-30', 'Moçambique'),
('Kamo-Kamo', 1, 'Médio', 5, '1998-05-18', 'Moçambique'),
('Reginaldo Faife', 1, 'Médio', 8, '1993-09-12', 'Moçambique'),
('Kalu Kalu', 1, 'Médio', 10, '1999-02-28', 'Moçambique'),
('Gildo Vilanculos', 1, 'Avançado', 9, '1996-12-05', 'Moçambique'),
('Stanley Ratifo', 1, 'Avançado', 11, '2000-04-20', 'Moçambique'),
('Telinho', 1, 'Médio', 6, '1997-08-14', 'Moçambique'),
('Betinho', 1, 'Avançado', 7, '1995-10-09', 'Moçambique');

-- Ferroviário de Maputo
INSERT INTO jogador (nome, equipa_id, posicao, numero, data_nascimento, nacionalidade) VALUES
('Soarito', 2, 'Guarda-Redes', 1, '1994-06-12', 'Moçambique'),
('Amade Momade', 2, 'Defesa', 2, '1996-09-18', 'Moçambique'),
('Gilberto', 2, 'Defesa', 3, '1995-11-25', 'Moçambique'),
('Nuro', 2, 'Defesa', 4, '1997-02-14', 'Moçambique'),
('Chamboco', 2, 'Médio', 5, '1998-07-30', 'Moçambique'),
('Chico Chicote', 2, 'Médio', 8, '1993-12-22', 'Moçambique'),
('Diogo', 2, 'Médio', 10, '1999-03-17', 'Moçambique'),
('Weza', 2, 'Avançado', 9, '1996-08-08', 'Moçambique'),
('Maguina', 2, 'Avançado', 11, '2000-01-15', 'Moçambique'),
('Latifo', 2, 'Médio', 6, '1997-05-20', 'Moçambique'),
('Macucua', 2, 'Avançado', 7, '1995-10-11', 'Moçambique');

-- Costa do Sol
INSERT INTO jogador (nome, equipa_id, posicao, numero, data_nascimento, nacionalidade) VALUES
('Kapequele', 3, 'Guarda-Redes', 1, '1996-02-28', 'Moçambique'),
('Nené', 3, 'Defesa', 2, '1997-06-14', 'Moçambique'),
('Mussagy', 3, 'Defesa', 3, '1995-09-22', 'Moçambique'),
('Almiro', 3, 'Defesa', 4, '1994-12-05', 'Moçambique'),
('Pena', 3, 'Médio', 5, '1998-04-18', 'Moçambique'),
('Pepo', 3, 'Médio', 8, '1993-08-30', 'Moçambique'),
('Abel', 3, 'Médio', 10, '1999-11-12', 'Moçambique'),
('Josemar', 3, 'Avançado', 9, '1996-03-25', 'Moçambique'),
('Shaquille', 3, 'Avançado', 11, '2000-07-07', 'Moçambique'),
('Telinho', 3, 'Médio', 6, '1997-10-16', 'Moçambique'),
('Chico', 3, 'Avançado', 7, '1995-01-29', 'Moçambique');

-- UD Songo
INSERT INTO jogador (nome, equipa_id, posicao, numero, data_nascimento, nacionalidade) VALUES
('Rafael', 4, 'Guarda-Redes', 1, '1995-05-10', 'Moçambique'),
('Bruno', 4, 'Defesa', 2, '1996-08-22', 'Moçambique'),
('Celso', 4, 'Defesa', 3, '1994-11-14', 'Moçambique'),
('Daniel', 4, 'Defesa', 4, '1997-03-05', 'Moçambique'),
('Eduardo', 4, 'Médio', 5, '1998-06-18', 'Moçambique'),
('Filipe', 4, 'Médio', 8, '1993-09-30', 'Moçambique'),
('Gustavo', 4, 'Médio', 10, '1999-12-12', 'Moçambique'),
('Hélder', 4, 'Avançado', 9, '1996-02-25', 'Moçambique'),
('Inocêncio', 4, 'Avançado', 11, '2000-05-07', 'Moçambique'),
('Jorge', 4, 'Médio', 6, '1997-07-16', 'Moçambique'),
('Kelvin', 4, 'Avançado', 7, '1995-10-29', 'Moçambique');

-- Ferroviário de Nampula
INSERT INTO jogador (nome, equipa_id, posicao, numero, data_nascimento, nacionalidade) VALUES
('Lucas', 5, 'Guarda-Redes', 1, '1994-03-08', 'Moçambique'),
('Manuel', 5, 'Defesa', 2, '1996-06-20', 'Moçambique'),
('Nélson', 5, 'Defesa', 3, '1995-09-12', 'Moçambique'),
('Oscar', 5, 'Defesa', 4, '1997-12-24', 'Moçambique'),
('Paulo', 5, 'Médio', 5, '1998-03-06', 'Moçambique'),
('Quintino', 5, 'Médio', 8, '1993-06-18', 'Moçambique'),
('Rui', 5, 'Médio', 10, '1999-09-30', 'Moçambique'),
('Sérgio', 5, 'Avançado', 9, '1996-12-12', 'Moçambique'),
('Tomás', 5, 'Avançado', 11, '2000-03-25', 'Moçambique'),
('Ulisses', 5, 'Médio', 6, '1997-06-07', 'Moçambique'),
('Vítor', 5, 'Avançado', 7, '1995-09-19', 'Moçambique');

-- Black Bulls
INSERT INTO jogador (nome, equipa_id, posicao, numero, data_nascimento, nacionalidade) VALUES
('Wilson', 6, 'Guarda-Redes', 1, '1995-02-15', 'Moçambique'),
('Xavier', 6, 'Defesa', 2, '1997-05-27', 'Moçambique'),
('Yuri', 6, 'Defesa', 3, '1996-08-09', 'Moçambique'),
('Zeca', 6, 'Defesa', 4, '1994-11-21', 'Moçambique'),
('Artur', 6, 'Médio', 5, '1998-02-03', 'Moçambique'),
('Benito', 6, 'Médio', 8, '1993-05-15', 'Moçambique'),
('Carlos', 6, 'Médio', 10, '1999-08-27', 'Moçambique'),
('David', 6, 'Avançado', 9, '1996-11-09', 'Moçambique'),
('Emerson', 6, 'Avançado', 11, '2000-02-21', 'Moçambique'),
('Francisco', 6, 'Médio', 6, '1997-05-04', 'Moçambique'),
('Gabriel', 6, 'Avançado', 7, '1995-08-16', 'Moçambique');

-- Incomáti FC
INSERT INTO jogador (nome, equipa_id, posicao, numero, data_nascimento, nacionalidade) VALUES
('Hugo', 7, 'Guarda-Redes', 1, '1994-01-12', 'Moçambique'),
('Igor', 7, 'Defesa', 2, '1996-04-24', 'Moçambique'),
('João', 7, 'Defesa', 3, '1995-07-06', 'Moçambique'),
('Kevin', 7, 'Defesa', 4, '1997-10-18', 'Moçambique'),
('Leonardo', 7, 'Médio', 5, '1998-01-30', 'Moçambique'),
('Miguel', 7, 'Médio', 8, '1993-04-12', 'Moçambique'),
('Nuno', 7, 'Médio', 10, '1999-07-24', 'Moçambique'),
('Otávio', 7, 'Avançado', 9, '1996-10-06', 'Moçambique'),
('Pedro', 7, 'Avançado', 11, '2000-01-18', 'Moçambique'),
('Quim', 7, 'Médio', 6, '1997-04-01', 'Moçambique'),
('Rodrigo', 7, 'Avançado', 7, '1995-07-13', 'Moçambique');

-- ENH Vilankulo
INSERT INTO jogador (nome, equipa_id, posicao, numero, data_nascimento, nacionalidade) VALUES
('Samuel', 8, 'Guarda-Redes', 1, '1995-03-20', 'Moçambique'),
('Tiago', 8, 'Defesa', 2, '1997-06-02', 'Moçambique'),
('Uilson', 8, 'Defesa', 3, '1996-09-14', 'Moçambique'),
('Valter', 8, 'Defesa', 4, '1994-12-26', 'Moçambique'),
('Washington', 8, 'Médio', 5, '1998-03-08', 'Moçambique'),
('Xico', 8, 'Médio', 8, '1993-06-20', 'Moçambique'),
('Yannick', 8, 'Médio', 10, '1999-09-02', 'Moçambique'),
('Zito', 8, 'Avançado', 9, '1996-12-14', 'Moçambique'),
('Alfredo', 8, 'Avançado', 11, '2000-03-27', 'Moçambique'),
('Bernardo', 8, 'Médio', 6, '1997-06-09', 'Moçambique'),
('Cristiano', 8, 'Avançado', 7, '1995-09-21', 'Moçambique');

-- Inserir Capitães (usando IDs dos jogadores)
INSERT INTO capitao (jogador_id, equipa_id, data_inicio) VALUES
(6, 1, '2024-01-01'),   -- Reginaldo Faife - Maxaquene
(17, 2, '2024-01-01'),  -- Chico Chicote - Ferroviário Maputo
(28, 3, '2024-01-01'),  -- Pepo - Costa do Sol
(39, 4, '2024-01-01'),  -- Filipe - UD Songo
(50, 5, '2024-01-01'),  -- Quintino - Ferroviário Nampula
(61, 6, '2024-01-01'),  -- Benito - Black Bulls
(72, 7, '2024-01-01'),  -- Miguel - Incomáti
(83, 8, '2024-01-01');  -- Xico - ENH Vilankulo

-- Inserir Árbitros
INSERT INTO arbitro (nome, categoria, nacionalidade, data_nascimento) VALUES
('João Silva', 'FIFA', 'Moçambique', '1980-05-15'),
('Carlos Mendes', 'Nacional', 'Moçambique', '1985-08-22'),
('António Costa', 'FIFA', 'Moçambique', '1978-11-10'),
('Manuel Santos', 'Nacional', 'Moçambique', '1982-03-18'),
('Pedro Alves', 'Internacional', 'Moçambique', '1975-07-25'),
('Ricardo Ferreira', 'Nacional', 'Moçambique', '1988-12-05'),
('José Mateus', 'FIFA', 'Moçambique', '1979-09-14'),
('Fernando Lima', 'Nacional', 'Moçambique', '1983-04-28');

-- Inserir Jogos (Rodada 1 e 2)
INSERT INTO jogo (equipa_casa_id, equipa_fora_id, data_hora, estadio, arbitro_id, golo_casa, golo_fora, rodada, status) VALUES
-- Rodada 1
(1, 2, '2024-11-20 15:00:00', 'Estádio do Maxaquene', 1, 2, 1, 1, 'finalizado'),
(3, 4, '2024-11-20 17:00:00', 'Estádio do Costa do Sol', 2, 1, 1, 1, 'finalizado'),
(5, 6, '2024-11-21 15:00:00', 'Estádio de Nampula', 3, 0, 2, 1, 'finalizado'),
(7, 8, '2024-11-21 17:00:00', 'Estádio do Incomáti', 4, 3, 0, 1, 'finalizado'),

-- Rodada 2
(2, 3, '2024-11-27 15:00:00', 'Estádio da Machava', 5, 1, 2, 2, 'finalizado'),
(4, 5, '2024-11-27 17:00:00', 'Estádio de Songo', 6, 2, 2, 2, 'finalizado'),
(6, 7, '2024-11-28 15:00:00', 'Estádio Nacional do Zimpeto', 7, 1, 0, 2, 'finalizado'),
(8, 1, '2024-11-28 17:00:00', 'Estádio de Vilankulo', 8, 0, 3, 2, 'finalizado');

-- Inserir Resumos dos Jogos
INSERT INTO resumo (jogo_id, resumo_text, espectadores, temperatura, condicao_clima) VALUES
(1, 'Maxaquene venceu num jogo equilibrado com golos de Gildo e Stanley. Ferroviário marcou com Weza.', 12000, 28.5, 'Ensolarado'),
(2, 'Empate justo entre Costa do Sol e UD Songo. Josemar marcou pelo Costa e Hélder pelo Songo.', 8500, 30.0, 'Muito calor'),
(3, 'Black Bulls dominou e venceu com dois golos de Gabriel. Ferroviário de Nampula não conseguiu responder.', 6000, 27.0, 'Nublado'),
(4, 'Incomáti mostrou força ofensiva com hat-trick de Rodrigo contra ENH Vilankulo.', 5000, 29.0, 'Ensolarado'),
(5, 'Costa do Sol virou o jogo no segundo tempo. Shaquille e Abel marcaram os golos da vitória.', 9000, 26.5, 'Parcialmente nublado'),
(6, 'Jogo movimentado terminou empatado. Eduardo e Jorge marcaram pelo Songo, Sérgio e Vítor pelo Ferroviário.', 7500, 31.0, 'Muito calor'),
(7, 'Black Bulls mantém 100% de aproveitamento com gol solitário de David.', 8000, 25.0, 'Agradável'),
(8, 'Maxaquene goleou fora de casa com hat-trick de Stanley Ratifo.', 4500, 28.0, 'Ensolarado');

-- Inserir Estatísticas de Jogadores
-- Jogo 1: Maxaquene 2-1 Ferroviário Maputo
INSERT INTO estatistica_jogador (jogo_id, jogador_id, gols, assistencias, cartao_amarelo, minutos_jogados) VALUES
(1, 8, 1, 0, 0, 90),  -- Gildo Vilanculos
(1, 9, 1, 1, 0, 90),  -- Stanley Ratifo
(1, 18, 1, 0, 0, 90), -- Weza
(1, 6, 0, 1, 1, 90);  -- Reginaldo (Capitão)

-- Jogo 2: Costa do Sol 1-1 UD Songo
INSERT INTO estatistica_jogador (jogo_id, jogador_id, gols, assistencias, cartao_amarelo, minutos_jogados) VALUES
(2, 30, 1, 0, 0, 90), -- Josemar
(2, 41, 1, 0, 0, 90); -- Hélder

-- Jogo 3: Ferroviário Nampula 0-2 Black Bulls
INSERT INTO estatistica_jogador (jogo_id, jogador_id, gols, assistencias, cartao_amarelo, minutos_jogados) VALUES
(3, 66, 2, 0, 0, 90); -- Gabriel

-- Jogo 4: Incomáti 3-0 ENH Vilankulo
INSERT INTO estatistica_jogador (jogo_id, jogador_id, gols, assistencias, cartao_amarelo, minutos_jogados) VALUES
(4, 77, 3, 0, 0, 90); -- Rodrigo

-- Jogo 5: Ferroviário Maputo 1-2 Costa do Sol
INSERT INTO estatistica_jogador (jogo_id, jogador_id, gols, assistencias, cartao_amarelo, minutos_jogados) VALUES
(5, 19, 1, 0, 0, 90), -- Maguina
(5, 31, 1, 0, 0, 90), -- Shaquille
(5, 29, 1, 1, 0, 90); -- Abel

-- Jogo 6: UD Songo 2-2 Ferroviário Nampula
INSERT INTO estatistica_jogador (jogo_id, jogador_id, gols, assistencias, cartao_amarelo, minutos_jogados) VALUES
(6, 37, 1, 0, 0, 90), -- Eduardo
(6, 42, 1, 0, 0, 90), -- Jorge
(6, 52, 1, 0, 1, 90), -- Sérgio
(6, 54, 1, 1, 0, 90); -- Vítor

-- Jogo 7: Black Bulls 1-0 Incomáti
INSERT INTO estatistica_jogador (jogo_id, jogador_id, gols, assistencias, cartao_amarelo, minutos_jogados) VALUES
(7, 63, 1, 0, 0, 90); -- David

-- Jogo 8: ENH Vilankulo 0-3 Maxaquene
INSERT INTO estatistica_jogador (jogo_id, jogador_id, gols, assistencias, cartao_amarelo, minutos_jogados) VALUES
(8, 9, 3, 0, 0, 90),  -- Stanley Ratifo
(8, 10, 0, 2, 0, 90); -- Telinho