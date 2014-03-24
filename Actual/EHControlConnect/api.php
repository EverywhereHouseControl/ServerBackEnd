<?
//API implementation to come here

function errorJson($msg){
	print json_encode(array('error'=>$msg));
	exit();
}

//--------------------------------------------------------------------------------------
function testNoERROR($error){
	//** TEST NO ERROR AT THIS POINT **
	if ($error <> 0) {
		// take de error message
		$message = query(	"SELECT ENGLISH, SPANISH
							FROM ERRORS
							WHERE ERRORCODE='%s' LIMIT 1 ", $error);
		print json_encode($message);
		exit();
	}
}
//--------------------------------------------------------------------------------------
function createJSON($iduser){
/* make the json of the user*/
	// "Rooms":{R1...R3{"name":"", "items":[]} } 
	// "User":"username"
	$SQLjson = query("SELECT HOUSENAME, ROOMNAME, SERVICENAME, ACTIONNAME
						FROM ACTIONS 
						JOIN (SERVICES ,ROOMS ,	(SELECT IDHOUSE, HOUSENAME
												 FROM HOUSES
												 WHERE IDHOUSE IN (	SELECT IDHOUSE
																	FROM ACCESSHOUSE
																	WHERE IDUSER='%s')) as T 
												)
						ON ( ACTIONS.IDSERVICE=SERVICES.IDSERVICE AND
							SERVICES.IDROOM=ROOMS.IDROOM AND 
							ROOMS.IDHOUSE=T.IDHOUSE)", $iduser);
	print json_encode($SQLjson);
}


//--------------------------------------------------------------------------------------
function login($user, $pass) {
/* make de server conexion*/
	$error = 0;
	
	$SQLuser = query("SELECT * FROM USERS WHERE USERNAME='%s'  limit 2", $user);
	$iduser  = $SQLuser['result'][0]['IDUSER'];
	$num	 = count($SQLuser['result']);
	
	switch ($num){
		case 0:	$error = 3;	break;
		case 2:	$error = 4;	break;
	}

	testNoERROR($error);
	
	//** TEST correct password **
	if ($SQLuser['result'][0]['PASSWORD'] == $pass){
		//correct pass, authorized
		$_SESSION['IdUser'] = $SQLuser['result'][0]['IDUSER'];
		$error = 0;
	}
	else{
		//incorrect pass. hint password
		$error = 2;
	}
	
	testNoERROR($error);
	
	//insert information about result of login.
	$sql = query("INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ACCESSRESULT, DATESTAMP        )
				VALUES  (     NULL,   '%s',    NULL,         '%s', CURRENT_TIMESTAMP)"
			, $iduser, $error);
	// take de error message
	$message = query(	"SELECT ENGLISH, SPANISH
						FROM ERRORS
						WHERE ERRORCODE='%s' LIMIT 1 ", $error);
	// return error
	testNoERROR($error);
	
	//successful function
	print json_encode($SQLuser);
	//createJSON($iduser);
}

//--------------------------------------------------------------------------------------
function lostpass($user){
/* envia un email al usuario que ha olvidado el password*/

	$result = query("SELECT * FROM USERS WHERE USERNAME='%s' limit 1", $user);
	
	if (count($result['result'])>0) {
	//existe al menos un usuario con ese nombre
		//ENVIAR CORREO AL USUARIO
		print json_encode($result['result'][0]['EMAIL']);
		
	} 
	else {
	//usuario incorrecto
		errorJson('The user does not exist.');
	}
}

//--------------------------------------------------------------------------------------
function createuser($user, $pass, $email, $hint){
/* create a new user*/
	$error = 0;
	$SQLuser = query("SELECT * FROM USERS WHERE USERNAME='%s' limit 2", $user);
	$iduser  = $SQLuser['result'][0]['IDUSER'];
	$num	 = count($SQLuser['result']);
	
	switch ($num){
		case 0:		$error = 0;	break;
		default:	$error = 6;	break;//this user already exists.
	}

	testNoERROR($error);
	
	//** INSERT NEW USER **
	$sql = query("INSERT INTO USERS
			       (IDUSER, USERNAME, PASSWORD, EMAIL, HINT, JSON,     DATEBEGIN) 
			VALUES (NULL,      '%s',    '%s',    '%s', '%s',   '', CURRENT_TIMESTAMP)"
			, $user, $pass, $email, $hint);
	//if (count($sql['error'])>0)  $error = 1;
	print json_encode($sql);
}

//--------------------------------------------------------------------------------------
function deleteuser($user, $pass){
	/* create a new user*/
	$error = 0;
	$SQLuser = query("SELECT * FROM USERS WHERE USERNAME='%s' limit 2", $user);
	$iduser  = $SQLuser['result'][0]['IDUSER'];
	$num	 = count($SQLuser['result']);

	switch ($num){
		case 1:		$error = 0;	break;
		default:	$error = 3;	break;//this user does not exists.
	}
	
	testNoERROR($error);
	
	//** TEST correct password **
	if ($SQLuser['result'][0]['PASSWORD']== $pass){
		$error = 0;
	}
	else{
		//incorrect pass. hint password
		$error = 2;
	}
	
	testNoERROR($error);

	//DELETE USER
	$sql = query("DELETE FROM USERS
			       WHERE USERNAME='%s'"
			, $user);
	//if (count($sql['error'])>0)  $error = 1;
	print json_encode($sql);
}

//--------------------------------------------------------------------------------------
function modifyuser($user, $pass, $n_user, $n_pass, $n_email, $n_hint){
	/* create a new user*/

	$SQLuser = query("SELECT * FROM USERS WHERE USERNAME='%s' limit 2", $user);
	$iduser  = $SQLuser['result'][0]['IDUSER'];
	$num	 = count($SQLuser['result']);

	switch ($num){
		case 1:		$error = 0;	break;
		default:	$error = 3;	break;//this user does not exists.
	}

	testNoERROR($error);
	
	//** TEST correct password **
	if ($SQLuser['result'][0]['PASSWORD'] == $pass){
		$error = 0;
	}
	else{
		$error = 2;//incorrect pass.
	}

	testNoERROR($error);

	//UPDATE USER
	$sql = query("UPDATE USERS 
				SET USERNAME='%s', PASSWORD='%s', EMAIL='%s', HINT='%s'
			    WHERE USERNAME='%s'"
			, $n_user, $n_pass, $n_email, $n_hint, $user);
	//if (count($sql['error'])>0)  $error = 1;
	print json_encode($sql);
}

//--------------------------------------------------------------------------------------
function doaction($user,$service,$action,$data) {
/* a user send a specific action aobut a service with or without data*/
	$error = 0;
	$SQLuser = query("SELECT * FROM USERS WHERE USERNAME='%s' limit 2", $user);
	$iduser  = $SQLuser['result'][0]['IDUSER'];
	$num	 = count($SQLuser['result']);
	$idaction =  query("SELECT  `FCODE` 
					    FROM    `ACTIONS` 
					    WHERE   `ACTIONNAME`='%s'", $action);
	switch ($num){
		case 0:	$error = 3;	break;
		case 2:	$error = 4;	break;
	}
	
	$code = query("SELECT  `FCODE` 
				   FROM    `ACTIONS` 
				   WHERE   `ACTIONNAME`='%s' AND 
						   `IDSERVICE` IN 
							(SELECT `IDSERVICE` 
							 FROM   `SERVICES` 
							 WHERE  `SERVICENAME` = '%s') limit 2", $action, $service);
	$num	 = count($code['result']);
	switch ($num){
		case 0:	$error = 5;	break;
		case 2:	$error = 4;	break;
	}
	
	//return
	if ($error <> 0) {
		$sql = query("INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ACCESSRESULT, DATESTAMP        )
				VALUES  (     NULL,   '%s',    NULL,         '%s', CURRENT_TIMESTAMP)"
				, $iduser, $error);
		$message = query(	"SELECT ENGLISH, SPANISH
						FROM ERRORS
						WHERE ERRORCODE='%s' LIMIT 1 ", $error);
		print json_encode(array('EXIT'=>$error).concat($message));
		exit();
	}
	

	//ENVIAR ACCION AL ARDUINO 
	//** print json_encode($code.concat(array('DATA'=>$data)));
	
	//ESPERAR RESPUESTA DEL ARDUINO.
	$returncode = "0X000001";	
	
	//COTEJAR RESPUESTA ARDUINO
	$sql = query("INSERT INTO HISTORYACCESS
						(`ID`, `IDACTION`, `IDPROGRAM`, `IDUSER`, `RETURNCODE`, `DATESTAMP`)
				VALUES  (NULL,   '%s',      NULL,         '%s',    '%s',  CURRENT_TIMESTAMP)"
			, $idaction, $returncode, $iduser);	
	//ENVIAR MENSAJE AL MOVIL.
	$result = query("SELECT `EXIT`,ENGLISH`,`SPANISH` 
					  FROM `ACTIONMESSAGES` 
					  WHERE `IDACTION`='%s' AND `RETURNCODE` = '%s'",  $idaction, $returncode);
	print json_encode($result);
	
}

//--------------------------------------------------------------------------------------
function createhouse($user, $house){
	/* create a new user*/

	$SQLuser = query("SELECT * FROM USERS WHERE USERNAME='%s' limit 2", $user);
	$iduser  = $SQLuser['result'][0]['IDUSER'];
	$num	 = count($SQLuser['result']);

	switch ($num){
		case 1:		$error = 0;	break;
		default:	$error = 3;	break;//this user does not exists.
	}

	testNoERROR($error);

	//** CREATE NEW HOUSE BY THIS USER **
	$sql = query("INSERT INTO HOUSES
			       (IDHOUSE, IDUSER, HOUSENAME, IPADRESS, GPS,       DATEBEGIN)
			VALUES (NULL,      '%s',    '%s',     '',    NULL, CURRENT_TIMESTAMP)"
			, $iduser, $house);
	//<-- OJO : IF SQL ERROR == TRUE//if (count($sql['error'])>0)  $error = 1;
	$SQLhouse = query("SELECT * FROM HOUSES WHERE HOUSENAME='%s' limit 2", $house);
	$idhouse  = $SQLhouse['result'][0]['IDHOUSE'];
	$num	  = count($SQLuser['result']);

	switch ($num){
		case 1:		$error = 0;	break;
		case 2:		$error = 4;	break;//DATA BASE INTEGRITY BREAK
		default:	$error = 8;	break;//this user does not exists.
	}
	
	testNoERROR($error);
	
	//CREATE PERMISSION TO ACCESS
	$sql = query("INSERT INTO ACCESSHOUSE
			       (IDUSER, IDHOUSE, ACCESSNUMBER,       DATEBEGIN)
			VALUES ('%s',      '%s',    1,       CURRENT_TIMESTAMP)"
			, $iduser, $house);
	//<-- OJO : IF SQL ERROR == TRUE//if (count($sql['error'])>0)  $error = 1;
	print json_encode($sql);
}

?>
