<?
//API implementation

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
function login($user, $pass) {
	/* make de server conexion*/
	$error = 0;
	$funct = 1;

	switch (testEXIST( 'USERS', 'USERNAME', $user)){
		case 1:	$error = 3;	break;
		case 4:	$error = 4;	break;
	}

	//only for save the iduser becouse we need that
	$SQLuser = query("SELECT * FROM USERS WHERE USERNAME='%s'  limit 2", $user);
	$iduser  = $SQLuser['result'][0]['IDUSER'];

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
}
//--------------------------------------------------------------------------------------
function testEXIST( $where, $something, $id) {
	/*TEST $somothing(IDUSER/IDHOUSE/ID..../HOUSENAME/ROOM....) EXIST ON TABLE $where BY THIS ENTRY $id*/
	$error = 0;
	$SQLuser = query("SELECT * FROM %s WHERE %s='%s' limit 2", $where, $something, $id);
	$num	 = count($SQLuser['result']);
	switch ($num){
		case 0:	$error = 1;	break;
		case 2:	$error = 4;	break;
	}
	return $error;
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
	$json .= '"House":"'.$SQLjson['result'][0]['HOUSENAME'].'",';
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
			       (IDUSER, USERNAME, PASSWORD, EMAIL, HINT,     DATEBEGIN)
			VALUES (NULL,      '%s',    '%s',    '%s', '%s', CURRENT_TIMESTAMP)"
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
//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
function testNoERROR2($iduser, $error, $funct){
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

	$json['error']['ENGLISH'] = utf8_encode($message['result'][0]['ENGLISH']);
	$json['error']['SPANISH'] = utf8_encode($message['result'][0]['SPANISH']);
	$json['error']['ERROR'] = $return;
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function createJSON2($user) {
//** creation of second type of json aplication uses**//

	$SQLjson = query ( "CALL loginJSON('%s');", $user );
	$num	 = count($SQLjson['result']);
	
	//TEST QUERY HAS AT LEAST one VALUE
	if ($num == 0){
		$JSON = null;
		return $JSON;
	}
	
	//var for register distinct SOCKET
	$tmpHOUSENAME 	= NULL;
	$tmpROOMNAME	= NULL;
	$tmpSERVICENAME = NULL;
	$tmpACTIONNAME  = NULL;
	
	//initialice values
	$JSON["houses"] = null;
	$h = -1;
	$r = -1;
	$s = -1;
	$a = -1;

	//print json_encode($JSON).$num;
	for($i = 0; $i < $num; $i++){
		
		switch (true) {
			
			case ($SQLjson['result'][$i]['HOUSENAME'] == NULL):
				continue;
				
			case ($tmpHOUSENAME <> $SQLjson['result'][$i]['HOUSENAME']):
				$r = 0;
				$s = 0;
				$a = 0;
				$h++;
				
				$JSON["houses"][$h]["name"]    = utf8_encode($SQLjson['result'][$i]['HOUSENAME']);
				$JSON["houses"][$h]["id"]    = utf8_encode($SQLjson['result'][$i]['IDHOUSE']);
				$JSON["houses"][$h]["access"]  = $SQLjson['result'][$i]['ACCESSNUMBER'];
				$JSON["houses"][$h]["weather"] = weatherJSON($SQLjson['result'][$i]['CITY'], $SQLjson['result'][$i]['COUNTRY'], 'en');
				$JSON["houses"][$h]["image"]   = ($SQLjson['result'][$i]['URL'] == NULL) ? NULL:'http://ehcontrol.net/EHControlConnect/'.utf8_encode($SQLjson['result'][$i]['URL']);
				
				if ($SQLjson['result'][$i]['ROOMNAME'] == NULL) {
					$JSON["houses"][$h]["rooms"] = null;
					break;
				}
				
				goto roomlabel;
				
			case ($SQLjson['result'][$i]['ROOMNAME'] == NULL):
				break;
				
			case ($tmpROOMNAME <> $SQLjson['result'][$i]['ROOMNAME']):
				$s = 0;
				$a = 0;
				$r++;
				
	roomlabel:	$JSON["houses"][$h]["rooms"][$r]["name"] = utf8_encode($SQLjson['result'][$i]['ROOMNAME']);
				$JSON["houses"][$h]["rooms"][$r]["id"]   = utf8_encode($SQLjson['result'][$i]['IDROOM']);
				
				if ($SQLjson['result'][$i]['SERVICENAME'] == NULL) {
					$JSON["houses"][$h]["rooms"][$r]["services"] = null;
					break;
				}
				
				goto servicelabel;
				
			case ($SQLjson['result'][$i]['SERVICENAME'] == NULL):	
				break;
				
			case ($tmpSERVICENAME <> $SQLjson['result'][$i]['SERVICENAME']):
				$a = 0;
				$s++;
				
servicelabel:	$JSON["houses"][$h]["rooms"][$r]["services"][$s]["name"]      = utf8_encode($SQLjson['result'][$i]['SERVICENAME']);
				$JSON["houses"][$h]["rooms"][$r]["services"][$s]["id"]        = $SQLjson['result'][$i]['IDSERVICE'];
				$JSON["houses"][$h]["rooms"][$r]["services"][$s]["interface"] = $SQLjson['result'][$i]['SERVICEINTERFACE'];
				$JSON["houses"][$h]["rooms"][$r]["services"][$s]["access"]    = $SQLjson['result'][$i]['PERMISSIONNUMBER'];
				$JSON["houses"][$h]["rooms"][$r]["services"][$s]["state"]     = utf8_encode($SQLjson['result'][$i]['STATUS']);
				
				if ($SQLjson['result'][$i]['ACTIONNAME'] == NULL) {
					$JSON["houses"][$h]["rooms"][$r]["services"][$s]["actions"] = null;
					break;
				}
				
				goto actionlabel;
				
			case ($SQLjson['result'][$i]['ACTIONNAME'] == NULL):
				break;
				
			case ($tmpACTIONNAME <> $SQLjson['result'][$i]['ACTIONNAME']):
				$a++;
				
actionlabel:	$JSON["houses"][$h]["rooms"][$r]["services"][$s]["actions"][$a]= utf8_encode($SQLjson['result'][$i]['ACTIONNAME']);
			default:
				
		}
		$tmpHOUSENAME 	= $SQLjson['result'][$i]['HOUSENAME'];
		$tmpROOMNAME	= $SQLjson['result'][$i]['ROOMNAME'];
		$tmpSERVICENAME = $SQLjson['result'][$i]['SERVICENAME'];
		$tmpACTIONNAME  = $SQLjson['result'][$i]['ACTIONNAME'];
	}

	return $JSON;
}

//--------------------------------------------------------------------------------------
function login2($user, $pass) {
/* make de server conexion*/
	$error = 0;
	$funct = 1;
	
	//only for save the iduser becouse we need that
	$SQLuser = query("SELECT * FROM USERS WHERE USERNAME='%s'  limit 2;", $user);
	$iduser  = $SQLuser['result'][0]['IDUSER'];
	$num	 = count($SQLuser['result']);
	switch ($num){
		case 0:	$error = 3;	break;
		case 2:	$error = 4;	break;
	}
	
	testNoERROR2($iduser, $error, $funct);
	
	//** TEST correct password **
	if ($SQLuser['result'][0]['PASSWORD'] == $pass){
		//correct pass, authorized
		$_SESSION['IdUser'] = $SQLuser['result'][0]['IDUSER'];
	}
	else{
		//incorrect pass. hint password
		$error = 2;
	}
	
	testNoERROR2($iduser, $error, $funct);
	
	$m = query("SELECT ENGLISH, SPANISH
				FROM ERRORS
				WHERE ERRORCODE=50 LIMIT 1; ");
	
	//REGISTER THE ACTIVITY
	$sql = query("INSERT INTO HISTORYACCESS
				(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
		VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP);"
			, $iduser, $error, $funct);
	
	//successful function
	$result['result'] = array_map('utf8_encode', $SQLuser['result'][0]);
	$result['result']['TASKS']    = taskJSON($user);
	$result['result']['COMMANDS'] = commandJSON($user);
	$result['result']['SINGLES']  = singleProgramJSON($user);
	$result['result']['DEVICES']  = deviceJSON($user);
	$result['result']['JSON']    = createJSON2($user);
	
	//$result['result']['COMMAND'] =commandJSON($user);
	
	$result['error']['ENGLISH'] = utf8_encode($m['result'][0]['ENGLISH']);
	$result['error']['SPANISH'] = utf8_encode($m['result'][0]['SPANISH']);
	$result['error']['ERROR'] 	= 0;
	
	print json_encode($result);
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
	
	//GENERATE NEW PASSWORD
	$pass = randomPass();
	
	$error = 12;//email password recovery sent.
	message($error, 0);	
	
	//set new password
	$message = query("CALL recoveryuser ('%s','%s')", $user, md5($pass));
	
	//take user email
	$email =  $message['result'][0]['EMAIL'];

	//server send an email recovery pasword
	recovery_mail($email, $user, $pass);
	
	
}

//--------------------------------------------------------------------------------------
function createuser2($user, $pass, $email, $hint){
	/* create a new user*/
	$message = query("CALL createuser ('%s','%s', '%s', '%s')", $user, $pass, $email, $hint);
	// take de error message
	
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	if ($json['error'][0]['ERROR'] == 0){
		welcome_mail($email, $user);
	}
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function deleteuser2($user, $pass){
	/* delete a existing user*/
	//take email before deletion
	$SQLuser = query("SELECT EMAIL FROM USERS WHERE USERNAME='%s'  limit 1", $user);
	$email  = $SQLuser['result'][0]['EMAIL'];

	$message = query("CALL deleteuser ('%s', '%s')", $user, $pass);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	if ($json['error']['ERROR'] == 0){
		goodbye_mail($email, $user);
	}
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function modifyuser2($user, $pass, $n_user, $n_pass, $n_email, $n_hint){
	/* create a new user*/
	$message = query("CALL modifyuser ('%s','%s','%s','%s','%s','%s')", $user, $pass, $n_user, $n_pass, $n_email, $n_hint);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function doaction($user,$house,$room,$service,$action,$data) {
/* a user send a specific action aobut a service with or without data*/
	$error = 0;
	$funct = 6;
	
	$SQLuser = query("SELECT * FROM USERS WHERE USERNAME='%s' limit 2", $user);
	$iduser  = $SQLuser['result'][0]['IDUSER'];
	$num	 = count($SQLuser['result']);
	switch ($num){
		case 0:	$error = 3;	break;
		case 2:	$error = 4;	break;
	}
	
	testNoERROR($iduser, $error, $funct);
	
	//TEST HOUSE EXIST
	switch (testEXIST( 'HOUSES', 'HOUSENAME', $house)){
		case 1:	$error = 8;	break;
		case 4:	$error = 4;	break;
	}
	testNoERROR($iduser, $error, $funct);
	
	//TEST ROOM EXIST
	$SQLuser = query("SELECT * 
						FROM ROOMS, HOUSES 
						WHERE ROOMS.IDHOUSE=HOUSES.IDHOUSE 
								AND ROOMS.ROOMNAME='%s'
								AND HOUSES.HOUSENAME='%s' limit 2", $room, $house);
	$num	 = count($SQLuser['result']);
	switch ($num){
		case 0:	$error = 9;break;
		case 2:	$error = 4;	break;
	}
	testNoERROR($iduser, $error, $funct);
	
	//TEST SERVICE EXIST
	$SQLuser = query("SELECT * 
						FROM ROOMS, HOUSES, SERVICES 
						WHERE ROOMS.IDHOUSE=HOUSES.IDHOUSE 
								AND SERVICES.IDROOM=ROOMS.IDROOM
								AND SERVICES.SERVICENAME='%s'
								AND ROOMS.ROOMNAME='%s'
								AND HOUSES.HOUSENAME='%s' limit 2", $service, $room, $house);
	$num	 = count($SQLuser['result']);
	switch ($num){
		case 0:	$error = 20;break;
		case 2:	$error = 4;	break;
	}
	testNoERROR($iduser, $error, $funct);
	
	//TEST ACTION EXIST
	$SQLuser = query("SELECT * 
						FROM ROOMS, HOUSES, SERVICES, ACTIONS
						WHERE ROOMS.IDHOUSE=HOUSES.IDHOUSE 
								AND SERVICES.IDROOM=ROOMS.IDROOM
								AND ACTIONS.IDSERVICE=SERVICES.IDSERVICE
								AND ACTIONS.ACTIONNAME='%s'
								AND SERVICES.SERVICENAME='%s'
								AND ROOMS.ROOMNAME='%s'
								AND HOUSES.HOUSENAME='%s' limit 2", $action, $service, $room, $house);
	$num	 = count($SQLuser['result']);
	switch ($num){
		case 0:	$error = 21;break;
		case 2:	$error = 4;	break;
	}
	testNoERROR($iduser, $error, $funct);
	
	//TEST HAVE ACCESS
	$SQLuser = query("SELECT * 
						FROM ACCESSHOUSE, USERS, HOUSES 
						WHERE ACCESSHOUSE.IDUSER=USERS.IDUSER 
								AND ACCESSHOUSE.IDHOUSE=HOUSES.IDHOUSE 
								AND USERS.USERNAME='%s'
								AND HOUSES.HOUSENAME='%s' limit 2", $user, $house);
	$num	 = count($SQLuser['result']);
	switch ($num){
		case 0:	$error = 11;break;
		case 2:	$error = 4;	break;
	}
	testNoERROR($iduser, $error, $funct);
	//if action == ENVIAR
	//GET THE FUNCTION CODE 
	$code = query("SELECT  FCODE 
				   FROM    HOUSES, ROOMS, SERVICES, USERS
				   WHERE   SERVICES.IDROOM=ROOMS.IDROOM
							AND ROOMS.IDHOUSE=HOUSES.IDHOUSE
							AND USERS.USERNAME='%s'
							AND HOUSES.HOUSENAME='%s'
							AND ROOMS.ROOMNAME='%s'
							AND SERVICES.SERVICENAME = '%s' limit 2", $user,$house,$room,$service);
	$num	 = count($code['result']);
	switch ($num){
		case 0:	$error = 5;	break;
		case 2:	$error = 4;	break;
	}

	testNoERROR($iduser, $error, $funct);
	
	//GETN THE IDENTIFICATOR
	$FCODE = $code['result'][0]['FCODE'];

	//GET THE IRCODE CODE
	if ($service == TV){
		//sent infrared code
		$code = query("SELECT  %s
					   FROM   IRCODES
					   WHERE  TYPE='%s' limit 2", $data,'TV NPG');
		$num	 = count($code['result']);
		
		switch ($num){
			case 0:	$error = 4;	break;
			case 2:	$error = 4;	break;
		}
		testNoERROR($iduser, $error, $funct);
		
		$IRCODE = '0132'.$code['result'][0][$data];
		$idaction = 1;
	}
	else{
		//sent on code
		$IRCODE = 0;
		$idaction = 0;
	}
	
	//SEND ENCODE ACTION TO THE RASPBERRY-ARDUINO SISTEM  $IRCODE.$FCODE;
	//header("Location: http://192.168.2.117/ejecuta.php?valor=".$IRCODE.$FCODE);
	//header("Location: http://mykelly.sytes.net/ejecuta.php?valor=".$IRCODE.$FCODE);
	//header("Content-Type: application/json");
	
	
	//REGISTER ARDUINO ANSWER
	$sql = query("INSERT INTO HISTORYACTION
						(`IDHISTORYACTION`, `IDACTION`, `IDPROGRAM`, `IDUSER`, `RETURNCODE`, `DATESTAMP`)
				VALUES  (NULL,                '%s',      NULL,           '%s',  '%s',  CURRENT_TIMESTAMP)"
			, $idaction, $iduser, $IRCODE.$FCODE);	

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
	
	print json_encode ($_SERVER['REMOTE_ADDR']);
	exit();
}

//--------------------------------------------------------------------------------------
function getweather($city,$language){
/* returns the weather of a specific city and country */
	$error = 0;
	$funct = 10;
	$iduser = 0;//administrator
	
	//REGISTER THE ACTIVITY
	$sql = query("INSERT INTO HISTORYACCESS
				(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
		VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP)"
			, $iduser, $error, $funct);
	
	exec('./clima ' .$city.' '. $language,$output);
	foreach($output as &$valor){
		echo ($valor);
		echo ("\n");
	}
	exit();
}

//--------------------------------------------------------------------------------------
function getweather2($city,$language){
	/* returns the weather of a specific city and country */
	$error = 0;
	$funct = 10;
	$iduser = 0;//administrator

	//REGISTER THE ACTIVITY
	$sql = query("INSERT INTO HISTORYACCESS
				(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
		VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP)"
			, $iduser, $error, $funct);

	exec('./clima ' .$city.' '. $language,$output);
	foreach($output as &$valor){
		return ($valor);
		echo ("\n");
	}
	return null;
}
//--------------------------------------------------------------------------------------
function weatherJSON($city, $country, $language){
	if (!empty($city)) {
		if (!empty($country)){
			//return getweather2($city.','.$country, $language);
		}
		else{
			//return getweather2($city, $language);
		}
	}
	return null;
}
//--------------------------------------------------------------------------------------
function createhouse($user, $house, $city, $country){
	/* create a new house + create access for this user to the house*/
	$message = query("CALL createhouse('%s', '%s', '%s', '%s')", $user, $house, $city, $country);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function modifyhouse($user, $house, $n_house, $image, $city, $country){
	/* modify information of house by an administrator*/
	$message = query("CALL modifyhouse('%s', '%s', '%s', %s, '%s', '%s')", $user, $house, $n_house,(int) $image, $city, $country);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}
//--------------------------------------------------------------------------------------
function deletehouse($user, $pass, $house){
	/*delete a existing house by an administrator user <-- user with access number 1*/
	$message = query("CALL deletehouse('%s', '%s', '%s')", $user, $pass, $house);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function createroom($user, $house, $room){
	/* create a new house + create access for this user to the house*/
	$message = query("CALL createroom('%s', '%s', '%s')", $user, $house, $room);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function deleteroom($user, $pass, $house, $room){
	/* create a new house + create access for this user to the house*/
	$message = query("CALL deleteroom('%s', '%s', '%s', '%s')", $user, $pass, $house, $room);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function createdevice($user, $ip, $serial, $device){
	/* create a new device*/
	$message = query("CALL createdevice('%s', '%s', '%s', '%s')", $user, $ip, $serial, $device);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function deletedevice($user, $pass, $iddevice){
	/* create a new device*/
	$message = query("CALL deletedevice('%s', '%s', %s)", $user, $pass, (int) $iddevice);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function createaccesshouse($user, $house, $user2, $n){
	/*create access to a house by an administrator <-- user with access number n*/
	$message = query("CALL createaccesshouse('%s', '%s', '%s', %s)",$user, $house, $user2, (int) $n);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function deleteaccesshouse($user, $house, $user2){
	/*delete access to a house by an administrator*/
	$message = query("CALL deleteaccesshouse('%s', '%s', '%s')",$user, $house, $user2);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function createprogramaction($user, $house, $room, $service, $action, $data, $start){
	/* create a new user*/
	$message = query("CALL createprogramaction ('%s','%s','%s','%s','%s','%s','%s', CURRENT_TIMESTAMP)", $user, $house, $room, $service, $action, $data, date("Y-m-d H:i:s",strtotime($start)) );
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function deleteprogramaction($user, $idaction){
	/* create a new user*/
	$message = query("CALL deleteprogramaction ('%s','%s')", $user, (int) $idaction);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function createtask($user, $task, $description, $frequency){
	/* create a new user*/
	$message = query("CALL createtask ('%s','%s','%s','%s')", $user, $task, $description, date("Y-m-d H:i:s",strtotime($frequency)) );
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function deletetask($user, $task){
	/* create a new user*/
	$message = query("CALL deletetask ('%s','%s')", $user, $task);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function addtaskprogram($user, $task, $idaction){
	/* create a new user*/
	$message = query("CALL addtaskprogram ('%s','%s',%s)", $user, $task, (int) $idaction );
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function removetaskprogram($user, $idtask, $idaction){
	/* create a new user*/
	$message = query("CALL removetaskprogram ('%s','%s','%s')",$user, (int) $idtask, (int) $idaction);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function addcommandprogram($user, $command, $idaction, $pos){
	/* create a new user*/
	$message = query("CALL addcommandprogram ('%s','%s',%s,%s)", $user, $command, (int) $idaction, (int) $pos);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function removecommandprogram($user, $command, $idaction, $pos){
	/* create a new user*/
	$message = query("CALL removecommandprogram ('%s','%s',%s,%s)",$user, $command, (int) $idaction, (int) $pos);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function createcommand($user, $command){
	/* */
	$message = query("CALL createcommand ('%s','%s')", $user, $command);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function deletecommand($user, $command){
	/* */
	$message = query("CALL deletecommand ('%s','%s')", $user, $command);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function linkserviceroom($idservice, $idroom){
	/* */
	$message = query("CALL linkserviceroom ('%s','%s')", $idservice, $idroom);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function unlinkserviceroom($idservice){
	/* */
	$message = query("CALL unlinkserviceroom ('%s')", $idservice);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}
//--------------------------------------------------------------------------------------
function taskJSON($user){

	$SQLjson = query ( "SELECT * 
						FROM taskVIEW 
						WHERE USERNAME = '%s'
						ORDER BY TASKNAME, STARTTIME ASC;", $user );
	$num	 = count($SQLjson['result']);
	
	//TEST QUERY HAS AT LEAST one VALUE
	if ($num == 0){
		$JSON = null;
		return $JSON;
	}
	
	//var for register distinct SOCKET
	$tmpTASKNAME 	= NULL;
	$tmpIDPROGRAM	= NULL;
	
	//initialice values
	$JSON = null;
	$t = -1;
	$p = -1;

	//print json_encode($JSON).$num;
	for($i = 0; $i < $num; $i++){
		
		switch (true) {
			
			case ($SQLjson['result'][$i]['TASKNAME'] == NULL):
				continue;
				
			case ($tmpTASKNAME <> $SQLjson['result'][$i]['TASKNAME']):
				$p = 0;
				$t++;
				
				$JSON[$t]["name"]  = utf8_encode($SQLjson['result'][$i]['TASKNAME']);
				$JSON[$t]["id"]    = $SQLjson['result'][$i]['IDTASK'];
				$JSON[$t]["user"]  = utf8_encode($SQLjson['result'][$i]['USERNAME']);
				
				if ($SQLjson['result'][$i]['IDPROGRAM'] == NULL) {
					$JSON[$t]["actions"] = null;
					break;
				}
				
				goto roomlabel;
				
			case ($SQLjson['result'][$i]['IDPROGRAM'] == NULL):
				break;
				
			case ($tmpIDPROGRAM <> $SQLjson['result'][$i]['IDPROGRAM']):
				$p++;
				
	roomlabel:	$JSON[$t]["actions"][$p]["idaction"] = $SQLjson['result'][$i]['IDPROGRAM'];
				$JSON[$t]["actions"][$p]["action"]  = utf8_encode($SQLjson['result'][$i]['ACTIONNAME']);
				$JSON[$t]["actions"][$p]["house"]   = utf8_encode($SQLjson['result'][$i]['HOUSENAME']);
				$JSON[$t]["actions"][$p]["room"]    = utf8_encode($SQLjson['result'][$i]['ROOMNAME']);
				$JSON[$t]["actions"][$p]["service"] = utf8_encode($SQLjson['result'][$i]['SERVICENAME']);
				$JSON[$t]["actions"][$p]["data"]    = utf8_encode($SQLjson['result'][$i]['DATA']);
				$JSON[$t]["actions"][$p]["starttime"]= $SQLjson['result'][$i]['STARTTIME'];
			
			default:
				
		}
		$tmpTASKNAME 	= $SQLjson['result'][$i]['TASKNAME'];
		$tmpIDPROGRAM	= $SQLjson['result'][$i]['IDPROGRAM'];
	}

	return $JSON;

}

//--------------------------------------------------------------------------------------
function commandJSON($user){

	$SQLjson = query ( "SELECT * 
						FROM commandVIEW 
						WHERE USERNAME = '%s'
						ORDER BY COMMANDNAME, POS ASC;", $user );
	$num	 = count($SQLjson['result']);
	
	//TEST QUERY HAS AT LEAST one VALUE
	if ($num == 0){
		$JSON = null;
		return $JSON;
	}
	
	//var for register distinct SOCKET
	$tmpCOMMANDNAME 	= NULL;
	$tmpIDPROGRAM	= NULL;
	
	//initialice values
	$JSON = null;
	$t = -1;
	$p = -1;

	//print json_encode($JSON).$num;
	for($i = 0; $i < $num; $i++){
		
		switch (true) {
			
			case ($SQLjson['result'][$i]['COMMANDNAME'] == NULL):
				continue;
				
			case ($tmpCOMMANDNAME <> $SQLjson['result'][$i]['COMMANDNAME']):
				$p = 0;
				$t++;
				
				$JSON[$t]["name"]  = utf8_encode($SQLjson['result'][$i]['COMMANDNAME']);
				$JSON[$t]["id"]    = $SQLjson['result'][$i]['IDCOMMAND'];
				$JSON[$t]["user"]  = utf8_encode($SQLjson['result'][$i]['USERNAME']);
				
				if ($SQLjson['result'][$i]['IDPROGRAM'] == NULL) {
					$JSON[$t]["actions"] = null;
					break;
				}
				
				goto roomlabel;
				
			case ($SQLjson['result'][$i]['IDPROGRAM'] == NULL):
				break;
				
			case ($tmpIDPROGRAM <> $SQLjson['result'][$i]['IDPROGRAM']):
				$p++;
				
	roomlabel:	$JSON[$t]["actions"][$p]["idaction"] = $SQLjson['result'][$i]['IDPROGRAM'];
				$JSON[$t]["actions"][$p]["action"]  = utf8_encode($SQLjson['result'][$i]['ACTIONNAME']);
				$JSON[$t]["actions"][$p]["house"]   = utf8_encode($SQLjson['result'][$i]['HOUSENAME']);
				$JSON[$t]["actions"][$p]["room"]    = utf8_encode($SQLjson['result'][$i]['ROOMNAME']);
				$JSON[$t]["actions"][$p]["service"] = utf8_encode($SQLjson['result'][$i]['SERVICENAME']);
				$JSON[$t]["actions"][$p]["data"]    = utf8_encode($SQLjson['result'][$i]['DATA']);
				$JSON[$t]["actions"][$p]["position"]= $SQLjson['result'][$i]['POS'];
			
			default:
				
		}
		$tmpCOMMANDNAME = $SQLjson['result'][$i]['COMMANDNAME'];
		$tmpIDPROGRAM	= $SQLjson['result'][$i]['IDPROGRAM'];
	}

	return $JSON;

}

//--------------------------------------------------------------------------------------
function singleProgramJSON($user){

	$SQLjson = query ( "SELECT *
						FROM singleProgramVIEW
						WHERE USERNAME = '%s'
						ORDER BY STARTTIME;", $user );
	$num	 = count($SQLjson['result']);

	//TEST QUERY HAS AT LEAST one VALUE
	if ($num == 0){
		$JSON = null;
		return $JSON;
	}

	//var for register distinct SOCKET
	$tmpIDPROGRAM	= NULL;

	//initialice values
	$JSON = null;
	$p = -1;

	//print json_encode($JSON).$num;
	for($i = 0; $i < $num; $i++){

		switch (true) {

			case ($SQLjson['result'][$i]['IDPROGRAM'] == NULL):
				break;

			case ($tmpIDPROGRAM <> $SQLjson['result'][$i]['IDPROGRAM']):
				$p++;

	roomlabel:	$JSON[$p]["idaction"] = $SQLjson['result'][$i]['IDPROGRAM'];
				$JSON[$p]["action"]  = utf8_encode($SQLjson['result'][$i]['ACTIONNAME']);
				$JSON[$p]["house"]   = utf8_encode($SQLjson['result'][$i]['HOUSENAME']);
				$JSON[$p]["room"]    = utf8_encode($SQLjson['result'][$i]['ROOMNAME']);
				$JSON[$p]["service"] = utf8_encode($SQLjson['result'][$i]['SERVICENAME']);
				$JSON[$p]["data"]    = utf8_encode($SQLjson['result'][$i]['DATA']);
				$JSON[$p]["starttime"]= $SQLjson['result'][$i]['STARTTIME'];
					
			default:

		}
		$tmpIDPROGRAM	= $SQLjson['result'][$i]['IDPROGRAM'];
	}

	return $JSON;

}

//--------------------------------------------------------------------------------------
function deviceJSON($user){

	$SQLjson = query ( "SELECT *
						FROM deviceVIEW
						WHERE USERNAME = '%s'
						ORDER BY IDDEVICE;", $user );
	$num	 = count($SQLjson['result']);

	//TEST QUERY HAS AT LEAST one VALUE
	if ($num == 0){
		$JSON = null;
		return $JSON;
	}

	//var for register distinct SOCKET
	$tmpIDDEVICE	= NULL;
	$tmpIDSERVICE	= NULL;

	//initialice values
	$JSON = null;
	$d = -1;
	$s = -1;

	//print json_encode($JSON).$num;
	for($i = 0; $i < $num; $i++){

		switch (true) {

			case ($SQLjson['result'][$i]['IDDEVICE'] == NULL):
				break;

			case ($tmpIDDEVICE <> $SQLjson['result'][$i]['IDDEVICE']):
				$d++;

				$JSON[$d]["iddevice"] = $SQLjson['result'][$i]['IDDEVICE'];
				$JSON[$d]["name"]     = utf8_encode($SQLjson['result'][$i]['DEVICENAME']);
				$JSON[$d]["ipaddress"]= utf8_encode($SQLjson['result'][$i]['IPADDRESS']);
				$JSON[$d]["serial"]   = utf8_encode($SQLjson['result'][$i]['SERIAL']);
				$JSON[$d]["english"]  = utf8_encode($SQLjson['result'][$i]['ENGLISH']);
				$JSON[$d]["spanish"]  = utf8_encode($SQLjson['result'][$i]['SPANISH']);
				
				if ($SQLjson['result'][$i]['IDSERVICE'] == NULL) {
					$JSON[$d]["services"] = null;
					break;
				}
				
				goto roomlabel;
				
			case ($SQLjson['result'][$i]['IDSERVICE'] == NULL):
				break;
				
			case ($tmpIDSERVICE <> $SQLjson['result'][$i]['IDSERVICE']):
				$s++;
				
	roomlabel:	$JSON[$d]["services"][$s]["name"]      = utf8_encode($SQLjson['result'][$i]['SERVICENAME']);
				$JSON[$d]["services"][$s]["idservice"] = utf8_encode($SQLjson['result'][$i]['IDSERVICE']);
				$JSON[$d]["services"][$s]["house"]     = ($SQLjson['result'][$i]['HOUSENAME'] == NULL) ? NULL:utf8_encode($SQLjson['result'][$i]['HOUSENAME']);
				$JSON[$d]["services"][$s]["room"]      = ($SQLjson['result'][$i]['ROOMNAME'] == NULL) ? NULL:utf8_encode($SQLjson['result'][$i]['ROOMNAME']);
					
			default:
				
			}
		$tmpIDDEVICE  = $SQLjson['result'][$i]['IDDEVICE'];
		$tmpIDSERVICE = $SQLjson['result'][$i]['IDSERVICE'];
	}
				
	return $JSON;

}

//--------------------------------------------------------------------------------------
function image($id){
	if ($id > 0){
		//vamos a crear nuestra consulta SQL
		//$consulta = "SELECT * FROM IMAGES WHERE IDIMAGE = $id";
		//con mysql_query la ejecutamos en nuestra base de datos indicada anteriormente
		//de lo contrario mostraremos el error que ocaciono la consulta y detendremos la ejecucion.
		$resultado= query("SELECT * FROM IMAGES WHERE IDIMAGE = %s", $id);
	
		//si el resultado fue exitoso
		//obtendremos el dato que ha devuelto la base de datos
		//$datos = mysql_fetch_assoc($resultado);
	
		//ruta va a obtener un valor parecido a "imagenes/nombre_imagen.jpg" por ejemplo
		$imagen = $resultado['result'][0]['IMAGE'];
		$url    = $resultado['result'][0]['URL'];
		$tipo   = $resultado['result'][0]['TYPE'];
		 
		if (count($resultado['result']) <> 0) {
			//ahora colocamos la cabeceras correcta segun el tipo de imagen
			header("Content-type: $tipo");//text/plain");
			//echo $imagen;
			echo '<img src='.$url.' width="100" heigth="100"/>';
		}
		else {
			echo 'this image does not exist.';
		}
		
	}
}

//--------------------------------------------------------------------------------------
function imageup($id){
	//comprobamos si ha ocurrido un error.
	if ( ! isset($_FILES["imagen"]) || $_FILES["imagen"]["error"] > 0){
		echo "ha ocurrido un error";
	} else {
		//ahora vamos a verificar si el tipo de archivo es un tipo de imagen permitido.
		//y que el tamano del archivo no exceda los 16mb
		$permitidos = array("image/jpg", "image/jpeg", "image/gif", "image/png");
		$limite_kb = 16384; //16mb es el limite de medium blob
		 
		if (in_array($_FILES['imagen']['type'], $permitidos) && $_FILES['imagen']['size'] <= $limite_kb * 1024){
			 
			//este es el archivo temporal
			$imagen_temporal  = $_FILES['imagen']['tmp_name'];
			//este es el tipo de archivo
			$tipo = $_FILES['imagen']['type'];
			//leer el archivo temporal en binario
			$fp     = fopen($imagen_temporal, 'r+b');
			$data = fread($fp, filesize($imagen_temporal));
			fclose($fp);
			//escapar los caracteres
			$data = mysql_escape_string($data);
	
			$resultado = mysql_query("INSERT INTO imagenes (imagen, tipo_imagen) VALUES ('$data', '$tipo')");
			if ($resultado){
				echo "el archivo ha sido copiado exitosamente";
			} else {
				echo "ocurrio un error al copiar el archivo.";
			}
		} else {
			echo "archivo no permitido, es tipo de archivo prohibido o excede el tamano de $limite_kb Kilobytes";
		}
	}
}
//--------------------------------------------------------------------------------------
function subir() {
	// comprobamos si ha ocurrido un error.
	if (! isset ( $_FILES ["imagen"] ) || $_FILES ["imagen"] ["error"] > 0) {
		print "ha ocurrido un error";
	} else {
		// ahora vamos a verificar si el tipo de archivo es un tipo de imagen permitido.
		// y que el tamano del archivo no exceda los 16mb
		$permitidos = array (
				"image/jpg",
				"image/jpeg",
				"image/gif",
				"image/png" 
		);
		$limite_kb = 16384; // 16mb es el limite de medium blob
		
		if (in_array ( $_FILES ['imagen'] ['type'], $permitidos ) && $_FILES ['imagen'] ['size'] <= $limite_kb * 1024) {
			
			// este es el archivo temporal
			$imagen_temporal = $_FILES ['imagen'] ['tmp_name'];
			// este es el tipo de archivo
			$tipo = $_FILES ['imagen'] ['type'];
			// leer el archivo temporal en binario
			$fp = fopen ( $imagen_temporal, 'r+b' );
			$data = fread ( $fp, filesize ( $imagen_temporal ) );
			fclose ( $fp );
			// escapar los caracteres
			//$data = mysql_escape_string($data);
			
			$resultado = query ( "INSERT INTO IMAGES (IDIMAGE, IMAGE, URL, TYPE) VALUES (NULL, '%s', '', '%s')", $data, $tipo );
			if ($resultado) {
				print "el archivo ha sido copiado exitosamente";
			} else {
				print "ocurrio un error al copiar el archivo.";
			}
		} else {
			print "archivo no permitido, es tipo de archivo prohibido o excede el tamano de $limite_kb Kilobytes";
		}
	}
}
//--------------------------------------------------------------------------------------
function subir2() {
	$image 	= $_FILES ['imagen'] ['name'];
	$ruta 	= $_FILES ['imagen'] ['tmp_name'];
	$tipo 	= $_FILES ['imagen'] ['type'];
	$destino = 'images/'.$image;
	if (copy($ruta,$destino)) {
		print '{"error":{"ERROR":0,"ENGLISH":"Uploaded image.","SPANISH":"Archivo subido."}';
	} else {
		print '{"error":{"ERROR":1,"ENGLISH":"Error on update image.","SPANISH":"Error al subir archivo."}';
	}
	$resultado = query ( "INSERT INTO IMAGES (IDIMAGE, IMAGE, URL, TYPE) 
									VALUES   (NULL, NULL, '%s', '%s')", $destino, $tipo);

	//echo "<img src=\"$destino\">";
	//print "$image $ruta $tipo $destino el archivo ha sido copiado exitosamente";
}
//--------------------------------------------------------------------------------------
function welcome_mail($email, $user){
	//header html mail
	$mail_headers="MIME-Version: 1.0\r\n";
	$mail_headers.="Content-type: text/html; charset=iso-8859-1\r\n";
	
	//header remiter
	$mail_headers.="From: EHC<proyectoehc@gmail.com>";
	
	$mail_message ='<p>&nbsp;</p>
		<p style="left: 65px; top: 1px; width: 202px; height: 202px; position: absolute;"><img style="display: block; margin-left: auto; margin-right: auto; top: 1px; left: 14px; width: 205px; height: 205px;" src="http://ehcontrol.net/images/logo.png" alt="" /></p>
		<p>&nbsp;</p>
		<h1 class="Text" style="position: absolute; left: 24px; top: 215px; width: 460px; height: 26px;"><span style="font-family: comic sans ms,sans-serif; font-size: x-large; color: #333399;"><span class="hps">Welcome to EHC.</span></span></h1>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<div style="position: absolute; left: 24px; top: 262px; width: 444px; height: 100px;">
		<p><span style="font-family: verdana,geneva; font-size: medium;">Congratulations! '.$user.' from now, you will experience the comfort about the mobile control of EHC.</span></p>
		<span style="font-family: verdana,geneva; font-size: medium;"> Hope you like.</span></div>';
	
	mail($email, "WELCOME EHC!", $mail_message, $mail_headers);
}
//--------------------------------------------------------------------------------------
function goodbye_mail($email,$user){
	//header html mail
	$mail_headers="MIME-Version: 1.0\r\n";
	$mail_headers.="Content-type: text/html; charset=iso-8859-1\r\n";
	
	//header remiter
	$mail_headers.="From: EHC<proyectoehc@gmail.com>";
	
	$mail_message ='<p>&nbsp;</p>
		<p style="left: 65px; top: 1px; width: 202px; height: 202px; position: absolute;"><img style="display: block; margin-left: auto; margin-right: auto; top: 1px; left: 14px; width: 205px; height: 205px;" src="http://ehcontrol.net/images/logo.png" alt="" /></p>
		<p>&nbsp;</p>
		<h1 class="Text" style="position: absolute; left: 24px; top: 215px; width: 460px; height: 26px;"><span style="font-family: comic sans ms,sans-serif; font-size: x-large; color: #333399;"><span class="hps">Account deleted.</span></span></h1>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<div style="position: absolute; left: 24px; top: 262px; width: 444px; height: 100px;">
		<p><span style="font-family: verdana,geneva; font-size: medium;">Good Bye! '.$user.', see you soon.</span></p>
		<span style="font-family: verdana,geneva; font-size: medium;"> EHC.</span></div>';
	
	mail($email, "GOOD BYE! from EHC", $mail_message, $mail_headers);
}
//--------------------------------------------------------------------------------------
function recovery_mail($email, $user, $pass){
	//header html mail
	$mail_headers="MIME-Version: 1.0\r\n";
	$mail_headers.="Content-type: text/html; charset=iso-8859-1\r\n";
	
	//header remiter
	$mail_headers.="From: EHC<proyectoehc@gmail.com>";
	
	$mail_message = '<p>&nbsp;</p>
			<p style="left: 65px; top: 1px; width: 202px; height: 202px; position: absolute;"><img style="display: block; margin-left: auto; margin-right: auto; top: 1px; left: 14px; width: 205px; height: 205px;" src="http://ehcontrol.net/images/logo.png" alt="" /></p>
			<p>&nbsp;</p>
			<h1 class="Text" style="position: absolute; left: 24px; top: 215px; width: 460px; height: 26px;"><span style="font-family: comic sans ms,sans-serif; font-size: x-large; color: #333399;"><span class="hps">Email</span> <span class="hps">password</span> <span class="hps">recovery</span>.</span></h1>
			<p>&nbsp;</p>
			<p>&nbsp;</p>
			<div style="position: absolute; left: 24px; top: 262px; width: 444px; height: 100px;">
			<p><span style="font-family: verdana,geneva; font-size: medium;">User:  '.$user.'</span></p>
			<p><span style="font-family: verdana,geneva; font-size: medium;">Pass:  '.$pass.'</span></p>
			</div>';
	
	mail($email, "Lost Password", $mail_message, $mail_headers);
}

//--------------------------------------------------------------------------------------
function randomPass(){
	//code from web
	//http://www.cristalab.com/tutoriales/script-generador-de-passwords-aleatorios-en-php-c8514l/
	$str = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789";
	$cad = "";
	for($i=0;$i<8;$i++) {
		$cad .= substr($str,rand(0,54),1);
	}
	return $cad;
}
?>

