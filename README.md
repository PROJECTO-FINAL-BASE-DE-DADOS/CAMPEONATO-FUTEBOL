# CAMPEONATO_FUTEBOL
Sistema web para gestão de campeonatos de futebol, permitindo cadastrar equipas, jogadores e resultados, com base de dados integrada para organização e acompanhamento das competições.
O sistema também permite realizar pesquisas atraves de vários parametros, de modo a facilitar o alcance dos objectivos.


# Database files generated for Campeonato_Futebol
Files included:
- create_tables.sql  -> schema (creates database 'campeonato' and tables)
- seed.sql           -> sample data
- conexao.php        -> example PHP connection using env vars
- docker-compose.yml -> optional MySQL service that imports the SQL files at container init
- README.md          -> this file

## Quick local import (MySQL installed on your PC)
1. Open terminal and login: mysql -u root -p
2. Create database and import schema: mysql -u root -p < create_tables.sql
   (or separately: CREATE DATABASE campeonato; mysql -u root -p campeonato < create_tables.sql)
3. Import seed data: mysql -u root -p campeonato < seed.sql

## Using Docker Compose (recommended for isolation)
1. Put these files into the project root (where docker-compose.yml is).
2. Run: docker compose up -d
3. The container will initialize and import create_tables.sql and seed.sql automatically.

## Notes
- Review foreign keys and adapt names to match exactly the backend PHP if necessary.
- If your backend expects different table/column names, update the SQL or the backend code to align.