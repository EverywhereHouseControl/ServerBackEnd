<?
session_start();
require("lib.php");
require("api.php");

header("Content-Type: application/json");

//API
switch ($_POST['command']) {
	case "login":
		login($_POST['username'], $_POST['password']); break;
    
	case "logout":
		logout(); sbreak;
	
	case "register":
		register($_POST['username'], $_POST['password'], $_POST['email'], $_POST['ficha1'], $_POST['ficha2']); break;
		
    case "getusers":
        getusers($_POST['username'],$_POST['usernameUser']); break;
        
	case "getuserAl":
        getuserAl($_POST['IdUser']); break;
		
    case "getgame":
        getgame($_SESSION['IdUser']); break;
        
    case "getthisgame":
        getthisgame($_POST['IdGame']); break;
}

exit();
?>