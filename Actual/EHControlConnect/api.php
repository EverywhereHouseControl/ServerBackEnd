<?
//API implementation to come here



//--------------------------------------------------------------------------------------
function errorJson($msg){
	print json_encode(array('error'=>$msg));
	exit();
}

//--------------------------------------------------------------------------------------
function testNoERROR($iduser, $error, $funct){
	//** TEST NO ERROR AT THIS POINT **
	if ($error <> 0) {
		//REGISTER THE ACTIVITY
		$sql = query("INSERT INTO HISTORYACCESS
					(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
			VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP)"
				, $iduser, $error, $funct);
		
		message($error, $error);
		exit();
	}
}
//--------------------------------------------------------------------------------------
function message($error, $return){
	// take de error message and return the error code to app
	$message = query(	"SELECT ENGLISH, SPANISH
					FROM ERRORS
					WHERE ERRORCODE='%s' LIMIT 1 ", $error);
	
	$json = '{"result":[{"ERROR":"'.$return.'","ENGLISH":"'.$message['result'][0]['ENGLISH'].'","SPANISH":"'.$message['result'][0]['SPANISH'].'"}]}';
	//$json = '{"result":[{"error":9}]}';
	print $json;
	//print json_encode($message);
	//print json_encode( (array) json_decode($json));
}

//--------------------------------------------------------------------------------------
function createJSON($iduser) {
	/* make the json of the user */
	// "Rooms":{R1...R3{"name":"", "items":[]} }
	// "User":"username"
	/*$SQLjson = query ( "SELECT USERNAME, HOUSENAME, ROOMNAME, SERVICENAME
						FROM USERS 
						JOIN (SERVICES, ROOMS, HOUSES ,ACCESSHOUSE)
						ON (
							SERVICES.IDROOM		= ROOMS.IDROOM 		 AND 
							ROOMS.IDHOUSE		= HOUSES .IDHOUSE	 AND 
                            HOUSES.IDHOUSE		= ACCESSHOUSE.IDHOUSE AND
                            ACCESSHOUSE.IDUSER	= USERS.IDUSER 		 AND
							USERS.IDUSER		= '%s')
						ORDER BY   USERNAME, HOUSENAME, ROOMNAME, SERVICENAME DESC", $iduser );*/
	$SQLjson = query ( "SELECT USERNAME, HOUSENAME, ROOMNAME, SERVICENAME
						FROM USERS
						JOIN (SERVICES, ROOMS, HOUSES, ACCESSHOUSE) 
						ON ( 		SERVICES.IDROOM = ROOMS.IDROOM
								AND ROOMS.IDHOUSE = HOUSES.IDHOUSE
								AND HOUSES.IDHOUSE = ACCESSHOUSE.IDHOUSE
								AND ACCESSHOUSE.IDUSER = USERS.IDUSER 
								AND USERS.IDUSER = '%s')
						ORDER BY USERNAME, HOUSENAME, ROOMNAME, SERVICENAME DESC", $iduser );
	$num	 = count($SQLjson['result']);
	
	//TEST QUERY HAS AT LEAST one VALUE
	if ($num == 0){
		$json = '';
		return $json;
	}
	//** creation of firt type of json aplication uses**
	$json = '{';
	$json .= '"User":"'.$SQLjson['result'][0]['USERNAME'].'",'; // "User":"username"
	$json .= '"Rooms":{';// "Rooms":{R1...R3{"name":"", "items":[]} }
	$json .= '"R1":{';
	$json .= '"name":"'.$SQLjson['result'][0]['ROOMNAME'].'",';
	$json .= '"items":[';
	$json .= '"'.$SQLjson['result'][0]['SERVICENAME'].'"';
	
	//var for register distinct service
	$tmpHOUSENAME 	= $SQLjson['result'][0]['HOUSENAME'];
	$tmpROOMNAME	= $SQLjson['result'][0]['ROOMNAME'];
	$tmpSERVICENAME = $SQLjson['result'][0]['SERVICENAME'];
	
	//var for write "R1" R1...R3
	$r = 1;
	for($i = 1; $i < $num; $i++){
		if (!($tmpHOUSENAME == $SQLjson['result'][$i]['HOUSENAME'])) {
			//$json .= "]}}";
			break;
		}
		if (!($tmpROOMNAME == $SQLjson['result'][$i]['ROOMNAME'])) {
			$json .= ']},';
			$json .= '"R'.(++$r).'":{';
			$json .= '"name":"'.$SQLjson['result'][$i]['ROOMNAME'].'",';
			$json .= '"items":[';
			$json .= '"'.$SQLjson['result'][$i]['SERVICENAME'].'"';
			
			$tmpHOUSENAME 	= $SQLjson['result'][$i]['HOUSENAME'];
			$tmpROOMNAME	= $SQLjson['result'][$i]['ROOMNAME'];
			$tmpSERVICENAME = $SQLjson['result'][$i]['SERVICENAME'];
			
			continue;
		}
		if (!($tmpSERVICENAME == $SQLjson['result'][$i]['SERVICENAME'])) {
			$json .= ',"'.$SQLjson['result'][$i]['SERVICENAME'].'"';
			
			$tmpHOUSENAME 	= $SQLjson['result'][$i]['HOUSENAME'];
			$tmpROOMNAME	= $SQLjson['result'][$i]['ROOMNAME'];
			$tmpSERVICENAME = $SQLjson['result'][$i]['SERVICENAME'];
			
			continue;
		}
	}
	$json .= ']}}';
	$json .= '}';
	return  $json;
	//return json_encode( (array) json_decode($json));
	//send json config to phone
	//$return = '{"result":[{"JSON":'.$json.',"ENGLISH":"'.$message['result'][0]['ENGLISH'].'","SPANISH":"'.$message['result'][0]['SPANISH'].'"}]}';
	//print json_encode( (array) json_decode($json));
	//print json_decode ( $json );//<---esto tendria que devolver un concat con EXIT
}

//--------------------------------------------------------------------------------------
function login($user, $pass) {
/* make de server conexion*/
	$error = 0;
	$funct = 1;
	
	$SQLuser = query("SELECT * FROM USERS WHERE USERNAME='%s'  limit 2", $user);
	$iduser  = $SQLuser['result'][0]['IDUSER'];
	$num	 = count($SQLuser['result']);
	
	switch ($num){
		case 0:	$error = 3;	break;
		case 2:	$error = 4;	break;
	}

	testNoERROR($iduser, $error, $funct);
	
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
	
	testNoERROR($iduser, $error, $funct);
	
	//REGISTER THE ACTIVITY
	$sql = query("INSERT INTO HISTORYACCESS
				(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
		VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP)"
			, $iduser, $error, $funct);
	
	//successful function
	$SQLuser['result'][0]['JSON'] = createJSON($iduser);
	$SQLuser['result'][0]['ERROR'] = '0';
	print json_encode($SQLuser);
	//print createJSON($iduser);
}

//--------------------------------------------------------------------------------------
function lostpass($user){
/* envia un email al usuario que ha olvidado el password*/
	$error = 0;
	$funct = 2;
	
	$SQLuser = query("SELECT * FROM USERS WHERE USERNAME='%s'  limit 2", $user);
	$iduser  = $SQLuser['result'][0]['IDUSER'];
	$num	 = count($SQLuser['result']);
	
	switch ($num){
		case 0:	$error = 3;	break;
		case 2:	$error = 4;	break;
	}

	testNoERROR($iduser, $error, $funct);
	
	/*
	 * 
	 * server send an email recovery pasword
	 * 
	 */
	
	//REGISTER THE ACTIVITY
	$sql = query("INSERT INTO HISTORYACCESS
				(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
		VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP)"
			, $iduser, $error, $funct);
	
	// take de error message
	$error = 12;//email password recovery sent.
	$message = query(	"SELECT ENGLISH, SPANISH
				FROM ERRORS
				WHERE ERRORCODE='%s' LIMIT 1 ", $error);
	
	message($error, 0);
}

//--------------------------------------------------------------------------------------
function createuser($user, $pass, $email, $hint){
/* create a new user*/
	$error = 0;
	$funct = 3;
	
	$SQLuser = query("SELECT * FROM USERS WHERE USERNAME='%s' limit 2", $user);
	$iduser  = $SQLuser['result'][0]['IDUSER'];
	$num	 = count($SQLuser['result']);
	
	switch ($num){
		case 0:		$error = 0;	break;
		default:	$error = 6;	break;//this user already exists.
	}

	testNoERROR($iduser, $error, $funct);
	
	//** INSERT NEW USER **
	$sql = query("INSERT INTO USERS
			       (IDUSER, USERNAME, PASSWORD, EMAIL, HINT, JSON,     DATEBEGIN) 
			VALUES (NULL,      '%s',    '%s',    '%s', '%s',   '', CURRENT_TIMESTAMP)"
			, $user, $pass, $email, $hint);
	
	//iduser UPDATE FOR NEW USER
	$SQLuser = query("SELECT * FROM USERS WHERE USERNAME='%s' limit 2", $user);
	$iduser  = $SQLuser['result'][0]['IDUSER'];
	
		//REGISTER THE ACTIVITY
	$sql = query("INSERT INTO HISTORYACCESS
				(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
		VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP)"
			, $iduser, $error, $funct);
	
	// take de error message
	$error = 13;//create new user
	message($error, 0);
}

//--------------------------------------------------------------------------------------
function deleteuser($user, $pass){
	/* create a new user*/
	$error = 0;
	$funct = 4;
	
	$SQLuser = query("SELECT * FROM USERS WHERE USERNAME='%s' limit 2", $user);
	$iduser  = $SQLuser['result'][0]['IDUSER'];
	$num	 = count($SQLuser['result']);

	switch ($num){
		case 1:		$error = 0;	break;
		default:	$error = 3;	break;//this user does not exists.
	}
	
	testNoERROR($iduser, $error, $funct);
	
	//** TEST correct password **
	if ($SQLuser['result'][0]['PASSWORD']== $pass){
		$error = 0;
	}
	else{
		//incorrect pass. hint password
		$error = 2;
	}
	
	testNoERROR($iduser, $error, $funct);

	//DELETE USER
	$sql = query("DELETE FROM USERS
			       WHERE USERNAME='%s'"
			, $user);
	
	//REGISTER THE ACTIVITY
	$sql = query("INSERT INTO HISTORYACCESS
				(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
		VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP)"
			, $iduser, $error, $funct);
	
	// take de error message
	$error = 14;//deleted user
	message($error, 0);
}

//--------------------------------------------------------------------------------------
function modifyuser($user, $pass, $n_user, $n_pass, $n_email, $n_hint){
	/* create a new user*/
	$error = 0;
	$funct = 5;
	
	$SQLuser = query("SELECT * FROM USERS WHERE USERNAME='%s' limit 2", $user);
	$iduser  = $SQLuser['result'][0]['IDUSER'];
	$num	 = count($SQLuser['result']);

	switch ($num){
		case 1:		$error = 0;	break;
		default:	$error = 3;	break;//this user does not exists.
	}

	testNoERROR($iduser, $error, $funct);
	
	//** TEST correct password **
	if ($SQLuser['result'][0]['PASSWORD'] == $pass){
		$error = 0;
	}
	else{
		$error = 2;//incorrect pass.
	}

	testNoERROR($iduser, $error, $funct);

	//UPDATE USER
	$sql = query("UPDATE USERS 
				SET USERNAME='%s', PASSWORD='%s', EMAIL='%s', HINT='%s'
			    WHERE USERNAME='%s'"
			, $n_user, $n_pass, $n_email, $n_hint, $user);
	
	//REGISTER THE ACTIVITY
	$sql = query("INSERT INTO HISTORYACCESS
				(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
		VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP)"
			, $iduser, $error, $funct);
	
	// take de error message
	$error = 15;//user MODIFY
	message($error, 0);
}

//--------------------------------------------------------------------------------------
function doaction($user,$house,$room,$service,$action,$data) {
/* a user send a specific action aobut a service with or without data*/
	$error = 0;
	$funct = 6;
	
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
	
	testNoERROR($iduser, $error, $funct);
	
	$code = query("SELECT  `FCODE` 
				   FROM    `ACTIONS` 
				   WHERE   `ACTIONNAME`='%s' AND 
						   `IDSERVICE` IN 
							(SELECT `IDSERVICE` 
							 FROM   `SERVICES` 
							 WHERE  `SERVICENAME` = '%s') limit 2", $user,$house,$room,$service,$action);
	$num	 = count($code['result']);
	switch ($num){
		case 0:	$error = 5;	break;
		case 2:	$error = 4;	break;
	}

	testNoERROR($iduser, $error, $funct);
	
	//ENVIAR ACCION AL ARDUINO 
	/*
	 * 
	 * print json_encode($code.concat(array('DATA'=>$data)));
	 * 
	 */
	
	//ESPERAR RESPUESTA DEL ARDUINO.
	$returncode = "0X000001";	
	
	//REGISTER ARDUINO ANSWER
	$sql = query("INSERT INTO HISTORYACTION
						(`ID`, `IDACTION`, `IDPROGRAM`, `IDUSER`, `RETURNCODE`, `DATESTAMP`)
				VALUES  (NULL,   '%s',      NULL,         '%s',    '%s',  CURRENT_TIMESTAMP)"
			, $idaction, $returncode, $iduser);	

	//REGISTER THE ACTIVITY
	$sql = query("INSERT INTO HISTORYACCESS
				(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
		VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP)"
			, $iduser, $error, $funct);
	
	// take de error message
	$error = 16;//acction sent
	message($error, 0);

}

//--------------------------------------------------------------------------------------
function createhouse($user, $house){
	/* create a new house + create access for this user to the house*/
	$error = 0;
	$funct = 7;
	
	$SQLuser = query("SELECT * FROM USERS WHERE USERNAME='%s' limit 2", $user);
	$iduser  = $SQLuser['result'][0]['IDUSER'];
	$num	 = count($SQLuser['result']);

	switch ($num){
		case 1:		$error = 0;	break;
		default:	$error = 3;	break;//this user does not exists.
	}

	testNoERROR($iduser, $error, $funct);

	//** CREATE NEW HOUSE BY THIS USER **
	$sql = query("INSERT INTO HOUSES
			       (IDHOUSE, IDUSER, HOUSENAME, IPADRESS, GPS,       DATEBEGIN)
			VALUES (NULL,      '%s',    '%s',     '',    NULL, CURRENT_TIMESTAMP)"
			, $iduser, $house);
	
	$SQLhouse = query("SELECT * FROM HOUSES WHERE HOUSENAME='%s' limit 2", $house);
	$idhouse  = $SQLhouse['result'][0]['IDHOUSE'];
	$num	  = count($SQLuser['result']);

	switch ($num){
		case 1:		$error = 0;	break;
		case 2:		$error = 4;	break;//DATA BASE INTEGRITY BREAK
		default:	$error = 8;	break;//this user does not exists.
	}
	
	testNoERROR($iduser, $error, $funct);
	
	//CREATE PERMISSION TO ACCESS
	$sql = query("INSERT INTO ACCESSHOUSE
			       (IDUSER, IDHOUSE, ACCESSNUMBER,       DATEBEGIN)
			VALUES ('%s',      '%s',    1,       CURRENT_TIMESTAMP)"
			, $iduser, $house);
	
	//REGISTER THE ACTIVITY
	$sql = query("INSERT INTO HISTORYACCESS
				(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
		VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP)"
			, $iduser, $error, $funct);
	
	// take de error message
	$error = 17;//create new house
	message($error, 0);
}

//--------------------------------------------------------------------------------------
function ipcheck(){
/* Returs Real Client IP */
	$error = 0;
	$funct = 8;
	$iduser = 0;//administrator
	
	//REGISTER THE ACTIVITY
	$sql = query("INSERT INTO HISTORYACCESS
				(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
		VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP)"
			, $iduser, $error, $funct);
	
	print json_encode($_SERVER['REMOTE_ADDR']);
	exit();
}

//--------------------------------------------------------------------------------------
function deletehouse($user, $pass, $house){
	/*delete a existing house by an administrator user <-- user with access number 1*/
	$error = 0;
	$funct = 9;
	
	$SQLuser = query("SELECT * FROM USERS WHERE USERNAME='%s' limit 2", $user);
	$iduser  = $SQLuser['result'][0]['IDUSER'];
	$num	 = count($SQLuser['result']);
	
	switch ($num){
		case 1:		$error = 0;	break;
		default:	$error = 3;	break;//this user does not exists.
	}
	
	testNoERROR($iduser, $error, $funct);
	
	//** THIS USER HAS PERMISSION IN THE HOUSE **
	$sql = query("SELECT * 
				FROM ACCESSHOUSE 
				WHERE 	IDUSER IN 
						   (SELECT IDUSER
							FROM USERS 
							WHERE USERNAME='%s') AND
						IDHOUSE IN 
						   (SELECT IDHOUSE
							FROM HOUSES 
							WHERE HOUSENAME='%s') limit 2", $user);
	if (count($sql['result'])) {
		$error = 18;//access require you have not access to this house
	}
	
	testNoERROR($iduser, $error, $funct);
	
	$idhouse = $sql['result'][0]['IDHOUSE'];
	if ($sql['result'][0]['ACCESSNUMBER'] <> 1){
		$error = 10;//permission require you are not a administrator
	}
	
	testNoERROR($iduser, $error, $funct);
	
	//DELETE HOUSE
	$sql = query("DELETE FROM HOUSES WHERE IDHOUSE='%s'"
			, $idhouse);
	
	//REGISTER THE ACTIVITY
	$sql = query("INSERT INTO HISTORYACCESS
				(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
		VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP)"
			, $iduser, $error, $funct);
	
	// take de error message
	$error = 19;//delete house
	message($error, 0);
}

?>

