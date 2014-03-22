<?
//API implementation to come here

function errorJson($msg){
	print json_encode(array('error'=>$msg));
	exit();
}

function login($user, $pass) {
/* REALIZA LA CONEXION CON EL SERVIDOR*/

	$result = query("SELECT * FROM USERS WHERE USERNAME='%s' limit 2", $user);
	
	if (count($result['result'])<=0) {
		errorJson('The user does not exist.');

	} 
	if (count($result['result'])>1) {
		errorJson('Database ACTIONS integrity broken.');
	}
	//usuario incorrecto
		//existe al menos un usuario con ese nombre
	//**TEST correct password.**
	if ($result['result'][0]['PASSWORD'] = $pass){
	
	//correct pass, authorized
		$_SESSION['IdUser'] = $result['result'][0]['IdUser'];
		print json_encode($result);//<- OJO MODIFICAR , NO SE PUEDE VOLCAR TODA INFORMACION DEL USUARIO
	}
	else{
	
	//incorrect pass. hint password
		print json_encode($result['result'][0]['HINT']);
	}

}

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

function doaction($user,$service,$action,$data) {
/* manda ejecutar una accion al arduino, sobre un servicio concreto*/
	$resultuser = query("SELECT IDUSER FROM USERS WHERE USERNAME='%s' limit 2", $user);
	//EXISTE EL USUARIOBUSCAMOS LA ACCION. 
	if (count($resultuser['result'])<=0) {
		errorJson('The user does not exist.');
		}
	if (count($resultuser['result'])>1) {
		errorJson('Database USERS integrity broken.');
		}
		
	$result = query("SELECT  `FCODE` 
					 FROM    `ACTIONS` 
					 WHERE 	 `ACTIONNAME`='%s' AND 
							 `IDSERVICE` NOT IN 
								(SELECT `IDSERVICE` 
								 FROM   `SERVICES` 
								 WHERE  `SERVICENAME` = '%s') limit 2", $action, $service);
	if (count($result['result'])<=0) {
		errorJson('The action or service does not exist.');
		}
	if (count($result['result'])>1) {
		errorJson('Database ACTIONS integrity broken.');
		}
	print json_encode($result);
	/*
		coger FCODE y concatenar con data y enviar a raspberry pi.
		ESPERAR CODIGO DE ENVIO Y DEVOLVER CODIGO DE ENVIO
		REGISTRAR EN LA BASE DE DATOS LA ACCION CON EL CODIGO DE RETORNO.*/
	
}

?>
