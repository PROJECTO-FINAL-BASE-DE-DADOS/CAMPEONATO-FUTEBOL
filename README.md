# PROJETO DE STARTUP BASEADO EM BASE DE DADOS
## Sistema de Gestão de Campeonatos de Futebol

---

## 1. IDENTIFICAÇÃO DO PROJETO

**Nome da Startup:** CAMPEONATO 3BD  
**Área de atuação:** Gestão Desportiva / Tecnologia  
**Integrantes da equipa:**
- Nerio Joao Jamisse (01.2418.2023) – Analista de Base de Dados
- Azarias – Programador Backend (PHP/SQL)
- Ornelio Magaia – Designer Frontend / Documentador

**Docente orientador:** Aurelio

---

## 2. DESCRIÇÃO DA IDEIA DE NEGÓCIO

### Problema Identificado
As organizações desportivas em Moçambique enfrentam dificuldades na gestão de campeonatos de futebol, incluindo:
- Falta de sistemas centralizados para gestão de dados
- Dificuldade em acompanhar estatísticas e classificações
- Processos manuais propensos a erros
- Ausência de plataformas acessíveis para consulta de informações

### Solução Proposta
O sistema **CAMPEONATO 3BD** é uma plataforma web que permite:
- Cadastro e gestão de equipas, jogadores, treinadores e árbitros
- Registo e acompanhamento de jogos e resultados
- Geração automática de classificações e estatísticas
- Visualização de artilheiros e próximos jogos
- Interface intuitiva acessível via navegador web

### Público-Alvo
- Federações e associações desportivas
- Clubes de futebol
- Organizadores de campeonatos locais e regionais
- Adeptos e media desportivo

### Valor ao Mercado
- **Eficiência:** Reduz tempo de gestão manual em até 80%
- **Precisão:** Elimina erros de cálculo e duplicação de dados
- **Transparência:** Informação acessível em tempo real
- **Profissionalização:** Eleva o padrão de gestão desportiva em Moçambique

---

## 3. OBJECTIVOS DO PROJETO

1. ✅ Criar e implementar uma base de dados relacional normalizada (3FN)
2. ✅ Garantir integridade referencial através de chaves estrangeiras
3. ✅ Desenvolver API REST em PHP para operações CRUD
4. ✅ Implementar interface web responsiva e intuitiva
5. ✅ Gerar relatórios e views SQL para classificação e estatísticas
6. ✅ Demonstrar funcionamento com dados reais de teste

---

## 4. LEVANTAMENTO DE REQUISITOS

### Requisitos Funcionais
- RF01: O sistema deve permitir cadastro de equipas com dados completos
- RF02: O sistema deve permitir cadastro de jogadores vinculados a equipas
- RF03: O sistema deve permitir cadastro de treinadores e capitães
- RF04: O sistema deve permitir cadastro de árbitros
- RF05: O sistema deve permitir registo de jogos com resultados
- RF06: O sistema deve gerar classificação automática das equipas
- RF07: O sistema deve listar artilheiros do campeonato
- RF08: O sistema deve permitir consulta de próximos jogos
- RF09: O sistema deve permitir edição inline de dados
- RF10: O sistema deve validar dados antes de inserção

### Requisitos Não Funcionais
- RNF01: Base de dados normalizada até 3ª Forma Normal (3FN)
- RNF02: Uso de SQL padrão (MySQL/MariaDB)
- RNF03: Interface acessível via navegador web moderno
- RNF04: Tempo de resposta inferior a 2 segundos
- RNF05: Sistema compatível com dispositivos móveis
- RNF06: Código documentado e organizado
- RNF07: Backup automático em localStorage

---

## 5. MODELAGEM DA BASE DE DADOS

### Modelo Conceitual (DER)

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   EQUIPA    │──────│  JOGADOR    │──────│  CAPITAO    │
└─────────────┘ 1:N  └─────────────┘ 1:N  └─────────────┘
      │                     │
      │ 1:N                 │ N:M
      │                     │
┌─────────────┐      ┌─────────────┐
│ TREINADOR   │      │ ESTATISTICA │
└─────────────┘      └─────────────┘
                            │
      ┌─────────────────────┴─────────────────────┐
      │                                           │
┌─────────────┐                            ┌─────────────┐
│    JOGO     │────────────────────────────│   RESUMO    │
└─────────────┘ 1:1                        └─────────────┘
      │ N:1
      │
┌─────────────┐
│   ARBITRO   │
└─────────────┘
```

### Modelo Lógico (Tabelas)

| Tabela | Atributos Principais |
|--------|----------------------|
| **equipa** | id (PK), nome, cidade, estadio, ano_fundacao |
| **jogador** | id (PK), nome, equipa_id (FK), posicao, numero, nacionalidade |
| **treinador** | id (PK), nome, nacionalidade, equipa_id (FK) |
| **capitao** | id (PK), jogador_id (FK), equipa_id (FK), data_inicio, data_fim |
| **arbitro** | id (PK), nome, categoria, nacionalidade |
| **jogo** | id (PK), equipa_casa_id (FK), equipa_fora_id (FK), data_hora, arbitro_id (FK), golo_casa, golo_fora, rodada, status |
| **resumo** | id (PK), jogo_id (FK), resumo_text, espectadores, temperatura |
| **estatistica_jogador** | id (PK), jogo_id (FK), jogador_id (FK), gols, assistencias, cartoes |

### Normalização

**1ª Forma Normal (1FN):**
- ✅ Todos os atributos são atómicos
- ✅ Não existem grupos repetitivos
- ✅ Cada tabela possui chave primária

**2ª Forma Normal (2FN):**
- ✅ Satisfaz 1FN
- ✅ Todos os atributos não-chave dependem totalmente da chave primária
- ✅ Não existem dependências parciais

**3ª Forma Normal (3FN):**
- ✅ Satisfaz 2FN
- ✅ Não existem dependências transitivas
- ✅ Atributos não-chave dependem apenas da chave primária

---

## 6. IMPLEMENTAÇÃO

### Tecnologias Utilizadas
- **Base de Dados:** MySQL 8.0
- **Backend:** PHP 7.4+ com MySQLi
- **Frontend:** HTML5, CSS3, JavaScript (ES6+)
- **Containerização:** Docker (opcional)

### Estrutura de Ficheiros
```
CAMPEONATO_FUTEBOL/
├── api/
│   ├── conexao.php          # Conexão com BD
│   ├── rows.php             # Leitura de dados
│   └── add_rows.php         # Inserção de dados
├── mysql/
│   ├── campeonato.sql       # Schema completo
│   ├── seed.sql             # Dados de teste
│   └── docker-compose.yml   # Container MySQL
├── public/
│   ├── index.html           # Página de jogadores
│   ├── css/style.css        # Estilos
│   ├── js/                  # Scripts JS
│   └── paginas/             # Páginas secundárias
└── README.md
```

### Exemplos de Código SQL

**Criação de Tabela:**
```sql
CREATE TABLE IF NOT EXISTS `equipa` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `cidade` VARCHAR(100) DEFAULT NULL,
  `estadio` VARCHAR(150) DEFAULT NULL,
  `ano_fundacao` YEAR DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_equipa_nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**View de Classificação:**
```sql
CREATE OR REPLACE VIEW vw_classificacao AS
SELECT 
  e.nome AS equipa,
  COUNT(j.id) AS jogos,
  SUM(CASE WHEN vitoria THEN 1 ELSE 0 END) AS vitorias,
  SUM(CASE WHEN empate THEN 1 ELSE 0 END) AS empates,
  SUM(CASE WHEN derrota THEN 1 ELSE 0 END) AS derrotas,
  SUM(gols_marcados) AS gols_marcados,
  SUM(gols_sofridos) AS gols_sofridos,
  (SUM(CASE WHEN vitoria THEN 3 ELSE 0 END) + 
   SUM(CASE WHEN empate THEN 1 ELSE 0 END)) AS pontos
FROM equipa e
LEFT JOIN jogos_processados j ON (j.equipa_id = e.id)
GROUP BY e.id, e.nome
ORDER BY pontos DESC, gols_marcados DESC;
```

**Query de Artilheiros:**
```sql
SELECT 
  jog.nome AS jogador,
  e.nome AS equipa,
  SUM(est.gols) AS total_gols
FROM jogador jog
JOIN equipa e ON jog.equipa_id = e.id
JOIN estatistica_jogador est ON jog.id = est.jogador_id
GROUP BY jog.id, jog.nome, e.nome
HAVING total_gols > 0
ORDER BY total_gols DESC
LIMIT 10;
```

---

## 7. TESTES E RESULTADOS

### Cenários de Teste

**Teste 1: Inserção de Equipa**
- Input: Nome="Maxaquene FC", Cidade="Maputo"
- Resultado: ✅ Equipa inserida com sucesso (ID=1)

**Teste 2: Inserção de Jogador**
- Input: Nome="Stanley Ratifo", Equipa=1, Posição="Avançado"
- Resultado: ✅ Jogador inserido com FK válida

**Teste 3: Registo de Jogo**
- Input: Casa=1, Fora=2, Golos: 2-1
- Resultado: ✅ Jogo registado, classificação atualizada

**Teste 4: Consulta de Classificação**
- Query: SELECT * FROM vw_classificacao
- Resultado: ✅ 8 equipas ordenadas por pontos

**Teste 5: Integridade Referencial**
- Tentativa: Apagar equipa com jogadores vinculados
- Resultado: ✅ Erro de FK (RESTRICT funcionando)

### Resultados Obtidos

📊 **Métricas do Sistema:**
- 8 equipas cadastradas
- 88 jogadores registados
- 8 jogos realizados
- 100% de integridade dos dados
- 0 registos duplicados

---

## 8. IMPACTO E SUSTENTABILIDADE

### Modelo de Negócio

**Fontes de Receita:**
1. **Assinaturas Mensais**
   - Plano Básico: 1.500 MT/mês (1 campeonato)
   - Plano Pro: 3.500 MT/mês (campeonatos ilimitados)
   - Plano Enterprise: 8.000 MT/mês (+ suporte dedicado)

2. **Serviços Adicionais**
   - Personalização de design: 5.000 MT
   - Integração com redes sociais: 2.500 MT
   - Relatórios customizados: 1.000 MT/relatório

3. **Publicidade**
   - Banners em páginas de classificação
   - Patrocínios de equipas

### Escalabilidade

**Fase 1 (Meses 1-6):** MVP com funcionalidades básicas  
**Fase 2 (Meses 7-12):** App móvel nativa  
**Fase 3 (Ano 2):** Expansão para outros desportos  
**Fase 4 (Ano 3):** Plataforma de streaming ao vivo

### Benefícios Sociais

- 🏆 Profissionalização do desporto moçambicano
- 📈 Transparência e credibilidade em competições
- 👨‍💼 Criação de empregos na área tech
- 🎓 Capacitação de profissionais locais
- 🌍 Visibilidade internacional para talentos nacionais

---

## 9. CONCLUSÕES

### Aprendizagens da Equipa

1. **Design de Base de Dados:** Importância da normalização e modelagem correta
2. **Programação Backend:** Segurança em queries SQL (prepared statements)
3. **Frontend Moderno:** JavaScript assíncrono e APIs REST
4. **Trabalho em Equipa:** Coordenação entre diferentes áreas técnicas
5. **Gestão de Projeto:** Priorização de funcionalidades e prazos

### Melhorias Futuras

**Curto Prazo:**
- ✨ Implementar autenticação de utilizadores
- ✨ Adicionar upload de fotos de jogadores
- ✨ Exportação de relatórios em PDF
- ✨ Sistema de notificações por email

**Médio Prazo:**
- 🚀 App móvel (React Native)
- 🚀 Módulo de transmissões ao vivo
- 🚀 IA para previsão de resultados
- 🚀 Integração com plataformas de apostas

**Longo Prazo:**
- 🌟 Expansão para outros países africanos
- 🌟 Marketplace de jogadores
- 🌟 Plataforma de e-learning para treinadores
- 🌟 Blockchain para contratos de jogadores

---

## 10. ANEXOS

### A. Código SQL Completo
- Ver ficheiro: `mysql/campeonato.sql`
- Ver dados de teste: `mysql/seed.sql`

### B. Diagramas
- Diagrama ER (Entidade-Relacionamento)
- Modelo Lógico
- Arquitetura do Sistema

### C. Screenshots
- Dashboard de classificação
- Gestão de jogadores
- Registo de jogos
- Relatórios de estatísticas

### D. Manual de Instalação

**Requisitos:**
- MySQL 8.0+
- PHP 7.4+
- Apache/Nginx
- Navegador moderno

**Passos:**
```bash
# 1. Clonar repositório
git clone https://github.com/user/campeonato_futebol.git

# 2. Importar base de dados
mysql -u root -p < mysql/campeonato.sql
mysql -u root -p campeonato < mysql/seed.sql

# 3. Configurar conexão
cp api/conexao.example.php api/conexao.php
# Editar credenciais no ficheiro

# 4. Iniciar servidor
php -S localhost:8000 -t public/

# 5. Aceder no navegador
http://localhost:8000
```

---

## REFERÊNCIAS

1. Elmasri, R., & Navathe, S. B. (2015). *Fundamentals of Database Systems*. 7th Edition.
2. Date, C. J. (2003). *An Introduction to Database Systems*. 8th Edition.
3. Documentação MySQL 8.0: https://dev.mysql.com/doc/
4. MDN Web Docs - JavaScript: https://developer.mozilla.org/
5. PHP Manual: https://www.php.net/manual/

---

**Desenvolvido por:** Nerio, Ornelio e Azarias  
**Data:** Dezembro 2025  
**Versão:** 1.0.0  
**Licença:** MIT