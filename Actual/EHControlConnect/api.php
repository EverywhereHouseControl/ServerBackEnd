<?
//API implementation to come here

function errorJson($msg){
	print json_encode(array('error'=>$msg));
	exit();
}

//--------------------------------------------------------------------------------------
function login($user, $pass) {
/* make de server conexion*/

	$result = query("SELECT * FROM USERS WHERE USERNAME='%s' limit 2", $user);
	$iduser = $result['result'][0]['IdUser'];
	$num	= count($result['result']);
	
	switch ($num){
		case 0:	$error = 3;	break;
		case 2:	$error = 4;	break;
	}

	//** TEST correct password **
	if ($result['result'][0]['PASSWORD'] = $pass){
		//correct pass, authorized
		$_SESSION['IdUser'] = $result['result'][0]['IdUser'];
		$error = 1;
	}
	else{
		//incorrect pass. hint password
		$error = 2;
	}
	
	//insert information about result of login.
	$sql = query("INSERT INTO HISTORYACCESS
						(IDHISTORY, IDUSER, IDHOUSE, ACCESSRESULT, DATESTAMP        )
				VALUES  (     NULL,   '%s',    NULL,         '%s', CURRENT_TIMESTAMP)"
			, $iduser, $error);
	// take de error message
	$message = query(	"SELECT ENGLISH, SPANISH
						FROM ERRORS
						WHERE ERRORCODE='%s' LIMIT 1 ", $error);
	//select return
	if ($error = 1) {
		print json_encode($result);
	}
	else{
		print json_encode($message);
		exit();
	}
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
function pulsadoMando($idUser,$idMando,$estado) {
    $tiempo = date("Y-m-d H:i:s");
    $result = query("UPDATE items SET status='%s' WHERE idTable='%s'",$estado,$idMando);
    
     if ($result == TRUE) {
        //authorized
        //	 $_SESSION['IdUser'] = $result['result'][0]['IdUser'];
        print json_encode($result);
    } else {
        //not authorized
        errorJson('Actualization failed');
    }
}

//--------------------------------------------------------------------------------------
function doaction($user,$service,$action,$data) {
/* a user send a specific action aobut a service with or without data*/
	
	$sqluser = query("SELECT IDUSER FROM USERS WHERE USERNAME='%s' limit 2", $user);
	
	//** TEST USER EXIST **
	if (count($sqluser['result'])<=0) {
		//insert information about result of doaction.
		$error = 3;
		$sql = query("INSERT INTO HISTORYACCESS
							(IDHISTORY,   IDUSER,    IDHOUSE, ACCESSRESULT, DATESTAMP)
					VALUES  (NULL, 			'%s', 		NULL, 	'%s', 	CURRENT_TIMESTAMP)"
				, $sqluser['result'][0]['IdUser'], $error);
		// take de error message
		$message = query(	"SELECT ENGLISH, SPANISH 
							 FROM ERRORS 
							 WHERE ERRORCODE='%s' LIMIT 1 ", $error);
		print json_encode($message);
		exit();
		}
		
	//** TEST USER UNIQUE **
	if (count($sqluser['result'])>1) {
		//insert information about result of login.
		$error = 4;
		$sql = query("INSERT INTO HISTORYACCESS
							(IDHISTORY,   IDUSER,    IDHOUSE, ACCESSRESULT, DATESTAMP)
					VALUES  (NULL, 			'%s', 		NULL, 	'%s', 	CURRENT_TIMESTAMP)"
				, $sqluser['result'][0]['IdUser'], $error);
		// take de error message
		$message = query(	"SELECT ENGLISH, SPANISH 
							 FROM ERRORS 
							 WHERE ERRORCODE='%s' LIMIT 1 ", $error);
		print json_encode($message);
		exit();
	}
		
	$code = query("SELECT  `FCODE` 
					 FROM    `ACTIONS` 
					 WHERE 	 `ACTIONNAME`='%s' AND 
							 `IDSERVICE` NOT IN 
								(SELECT `IDSERVICE` 
								 FROM   `SERVICES` 
								 WHERE  `SERVICENAME` = '%s') limit 2", $action, $service);
	//** TEST ACTION-SERVICE EXIST**
	if (count($code['result'])<=0) {
		//insert information about result of doaction.
		$error = 5;
		$sql = query("INSERT INTO HISTORYACCESS
							(IDHISTORY,   IDUSER,    IDHOUSE, ACCESSRESULT, DATESTAMP)
					VALUES  (NULL, 			'%s', 		NULL, 	'%s', 	CURRENT_TIMESTAMP)"
				, $result['result'][0]['IdUser'], $error);
		// take de error message
		$message = query(	"SELECT ENGLISH, SPANISH
							 FROM ERRORS
							 WHERE ERRORCODE='%s' LIMIT 1 ", $error);
		print json_encode($message);
		exit();
		}
		
	//** TEST ACTION-SERVICE UNIQUE **
	if (count($code['result'])>1) {
		//insert information about result of login.
		$error = 4;
		$sql = query("INSERT INTO HISTORYACCESS
							(IDHISTORY,   IDUSER,    IDHOUSE, ACCESSRESULT, DATESTAMP)
					VALUES  (NULL, 			'%s', 		NULL, 	'%s', 	CURRENT_TIMESTAMP)"
				, $result['result'][0]['IdUser'], $error);
		// take de error message
		$message = query(	"SELECT ENGLISH, SPANISH 
							 FROM ERRORS 
							 WHERE ERRORCODE='%s' LIMIT 1 ", $error);
		print json_encode($message);
		exit();
		}
		
	//ENVIAR ACCION AL ARDUINO 
	//print json_encode($code);
	//ESPERAR RESPUESTA DEL ARDUINO.
	//$arduino = ...	
	//COTEJAR RESPUESTA ARDUINO
	//ENVIAR MENSAJE AL MOVIL.
	print json_encode($result);
	/*
		coger FCODE y concatenar con data y enviar a raspberry pi.
		ESPERAR CODIGO DE ENVIO Y DEVOLVER CODIGO DE ENVIO
		REGISTRAR EN LA BASE DE DATOS LA ACCION CON EL CODIGO DE RETORNO.*/
	
}

?>
