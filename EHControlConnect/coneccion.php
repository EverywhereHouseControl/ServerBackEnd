<?php
/**
 * Variables de acceso a la base de datos
 */

/*
 
*/

define('DB_HOST', "localhost");
define('DB_USER', "root");
define('DB_PASSWORD', "bd_proyectois");
define('DB_DB', "ehcontrol");


define('SHOW_MYSQL_ERRORS', true);

//connexion to the database

global $link;
$link = @mysql_connect(DB_HOST, DB_USER, DB_PASSWORD);
$db = @mysql_select_db(DB_DB);
@mysql_query("SET NAMES 'utf8'");

//errors we see in the log file
if(!$link && !$db){
    echo "status=error&error=" . urlencode("Ha acurrido un error de conexi?. Por favor intentelo de nuevo mas tarde.");
    if(SHOW_MYSQL_ERRORS){
        echo urlencode("\n\nError de MySQL:\n" . mysql_error());
    }
    exit();
}
?>
