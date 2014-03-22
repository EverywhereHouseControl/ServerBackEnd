<?
session_start();
require("lib.php");
require("api.php");

header("Content-Type: application/json");

//API
switch ($_POST['command']) {
	case "login":
		login($_POST['username'], $_POST['password']); 
	break;
	
    case "lostpass":
		lostpass($_POST['username']); 
	break;	
	
	case "doaction":
		doaction($_POST['username'],$_POST['servicename'],$_POST['actionname'],$_POST['data']); 
	break;

	/*
    case "downloadconfiguration":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "downloadstadistics":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "downloadhousetask":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "downloadusertask":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "logout":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "createuser":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "deleteuser":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "modifyuser":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "modifyuserconfiguration":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "modifyhouseconfiguration":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "createtask":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "deletetask":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "modifytask":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "createprogramaction":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "deleteprogramaction":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "update":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "notify":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "sendmessage":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "createdevice":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "deletedevice":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "createhouse":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "deletehouse":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "modifyhouse":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "createroom":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "deleteroom":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "modifyroom":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "createpermission":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "deletepermission":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "modifypermission":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "createaccess":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "modifyaccess":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "requestaccess":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "requestpermission":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "generatebackup":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "loadbackup":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "redo":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "undo":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "listdo":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "doaction":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "a":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "a":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "a":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "a":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "a":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "a":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "a":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "a":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "a":
		a($_POST['arg1'],$_POST['arg2']); 
	break;*/
}

exit();
?>