<?php
/**
 * Variables de acceso a la base de datos
 */

/*
define('DB_HOST', "internal-db.s63827.gridserver.com");
define('DB_USER', "db63827_dev");
define('DB_PASSWORD', "mauro123");
define('DB_DB', "db63827_roodos_cl");
*/

define('DB_HOST', "localhost");
define('DB_USER', "root");
define('DB_PASSWORD', "bd_proyectois");
define('DB_DB', "ehcontrol");


define('SHOW_MYSQL_ERRORS', true);


global $link;
$link = @mysql_connect(DB_HOST, DB_USER, DB_PASSWORD);
$db = @mysql_select_db(DB_DB);
@mysql_query("SET NAMES 'utf8'");

if(!$link && !$db){
    echo "status=error&error=" . urlencode("Ha acurrido un error de conexi?. Por favor intentelo de nuevo mas tarde.");
    if(SHOW_MYSQL_ERRORS){
        echo urlencode("\n\nError de MySQL:\n" . mysql_error());
    }
    exit();
}
?>
