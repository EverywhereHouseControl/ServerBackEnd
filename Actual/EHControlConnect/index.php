<?
session_start();
require("lib.php");
require("api.php");

header("Content-Type: application/json");

//API
switch ($_POST['command']) {
//-------------------------------------------------------------------------------------------------	
	case "ipcheck":
		ipcheck(); 
		// ::> returns real client ip
		break;
//-------------------------------------------------------------------------------------------------	
	case "login":
		login($_POST['username'], $_POST['password']); 
		//**grant a user access to the aplication 
		// ::> returns a message | return JSON configuration
		break;
	
    case "lostpass":
		lostpass($_POST['username']); 
		//**send an email to the email of the username
		// ::> returns a message | returns the result of the operation
		break;	
	
    case "createuser":
		createuser($_POST['username'],$_POST['password'],$_POST['email'],$_POST['hint']); 
		//**create a new user account
		// ::> returns a message | returns the result of the operation
		break;
	
	case "deleteuser":
		deleteuser($_POST['username'],$_POST['password']);
		//**delete a existing user
		// ::> returns a message | returns the result of the operation
		break;
	
	case "modifyuser":
		modifyuser($_POST['username'],$_POST['password'],$_POST['n_username'],$_POST['n_password'],$_POST['n_email'],$_POST['n_hint']);
		//**modify all fields
		// ::> returns a message | returns the result of the operation
		break;
	
	case "doaction":
		doaction($_POST['username'],$_POST['servicename'],$_POST['actionname'],$_POST['data']); 
		//**send an action to the arduino to be done
		// ::> returns a message
		break;
	
	case "createhouse":
		createuser($_POST['username'],$_POST['housename']);
		//**create a new house with an existing user
		// ::> returns a message | returns the result of the operation
		break;
//-------------------------------------------------------------------------------------------------	
	case "deletehouse":
		deletehouse($_POST['username'],$_POST['password'],$_POST['housename']);
		//**delete a existing house by an administrator user
		// ::> returns a message | returns the result of the operation
		break;
		
	case "modifyhouse":
		modifyhouse($_POST['username'],$_POST['password'],$_POST['housename']);
		//**modify setings of an existing the house
		// ::> returns a message | returns the result of the operation
		break;
	
	case "createroom":
		createroom($_POST['username'],$_POST['roomname']);
		//**create a new room with an existing user
		// ::> returns a message | returns the result of the operation
		break;
	
	case "deleteroom":
		deleteroom($_POST['username'],$_POST['password'],$_POST['roomname']);
		//**delete a existing room by an administrator user
		// ::> returns a message | returns the result of the operation
		break;
	
	case "modifyroom":
		modifyroom($_POST['username'],$_POST['password'],$_POST['roomname']);
		//**modify setings of an existing the room
		// ::> returns a message | returns the result of the operation
		break;
	
    case "downloadconfiguration":
		downloadconfiguration($_POST['username'], $_POST['snoopy_username']); 
		//**download the json configuration of username by snoopy_username
		// ::> returns a message | returns JSON
	break;
		
    case "downloadstadistics":
		downloadstadistics($_POST['username']);
		//**download the STADISTICS of username by using and more
		// ::> returns a message | returns JSON 
	break;
		/*
    case "downloadhousetask":
		downloadhousetask($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "downloadusertask":
		downloadusertask($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "logout":
		logout($_POST['arg1'],$_POST['arg2']); 
	break;*/

		

		/*
    case "modifyuserconfiguration":
		modifyuserconfiguration($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "modifyhouseconfiguration":
		modifyhouseconfiguration($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "createtask":
		createtask($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "deletetask":
		deletetask($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "modifytask":
		modifytask($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "createprogramaction":
		createprogramaction($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "deleteprogramaction":
		deleteprogramaction($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "update":
		update($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "notify":
		notify($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "sendmessage":
		sendmessage($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "createdevice":
		createdevice($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "deletedevice":
		deletedevice($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*


		/*
    case "createpermission":
		createpermission($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "deletepermission":
		deletepermission($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "modifypermission":
		modifypermission($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "createaccess":
		createaccess($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "modifyaccess":
		modifyaccess($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "requestaccess":
		requestaccess($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "requestpermission":
		requestpermission($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "generatebackup":
		generatebackup($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "loadbackup":
		loadbackup($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "redo":
		redo($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "undo":
		undo($_POST['arg1'],$_POST['arg2']); 
	break;*/
		/*
    case "listdo":
		listdo($_POST['arg1'],$_POST['arg2']); 
	break;*/
//_-------------------------
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
