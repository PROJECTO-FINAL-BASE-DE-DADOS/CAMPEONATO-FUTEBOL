<! DOCTYPE html>
<html>
    <head>
        <title>
            Conexao_DB_Front_End

        </title>
    </head>
    <body>

        <?php
        // cria uma conexao entre o php e a base de dados campeonato que esta localizada
        //num servidor local designado por=localhost, cujo o usuario=root e a password...
            $DB=new mysqli('localhost','root','password?','campeonato');

            if($DB->connect_error){die("Erro de conexao".$DB->connect_error);
            }

        ?>
    </body>




</html>