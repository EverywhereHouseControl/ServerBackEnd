<?
//API implementation

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
function testNoERROR2($iduser, $error, $funct){
	//** TEST NO ERROR AT THIS POINT **
	if ($error <> 0) {
		//REGISTER THE ACTIVITY
		$sql = query("INSERT INTO HISTORYACCESS
					(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
			VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP)"
				, $iduser, $error, $funct);

		message2($error, $error);
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
function message2($error, $return){
	// take de error message and return the error code to app
	$message = query(	"SELECT ENGLISH, SPANISH
					FROM ERRORS
					WHERE ERRORCODE='%s' LIMIT 1 ", $error);

	//$json = '{"error":{"ERROR":"'.$return.'","ENGLISH":"'.$message['result'][0]['ENGLISH'].'","SPANISH":"'.$message['result'][0]['SPANISH'].'"}}';
	//$json = '{"result":[{"error":9}]}';utf8_encode(
	$json['error']['ENGLISH'] = utf8_encode($message['result'][0]['ENGLISH']);
	$json['error']['SPANISH'] = utf8_encode($message['result'][0]['SPANISH']);
	$json['error']['ERROR'] = $return;
	print json_encode($json);
	//print json_encode($message);
	//print json_encode( (array) json_decode($json));
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
function createJSON2($user) {
//** creation of second type of json aplication uses**//

	$SQLjson = query ( "CALL loginJSON('%s')", $user );
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
				
				$JSON["houses"][$h]["name"]   = utf8_encode($SQLjson['result'][$i]['HOUSENAME']);
				$JSON["houses"][$h]["access"] = $SQLjson['result'][$i]['ACCESSNUMBER'];
				
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
				
	roomlabel:	$JSON["houses"][$h]["rooms"][$r]["name"]     = utf8_encode($SQLjson['result'][$i]['ROOMNAME']);
				
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
				
servicelabel:	$JSON["houses"][$h]["rooms"][$r]["services"][$s]["name"]   = utf8_encode($SQLjson['result'][$i]['SERVICENAME']);
				$JSON["houses"][$h]["rooms"][$r]["services"][$s]["id"]     = $SQLjson['result'][$i]['SERVICEINTERFACE'];
				$JSON["houses"][$h]["rooms"][$r]["services"][$s]["access"] = $SQLjson['result'][$i]['PERMISSIONNUMBER'];
				$JSON["houses"][$h]["rooms"][$r]["services"][$s]["state"]  = 1;//servicestate();print 'null';
				
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
	//print json_encode($JSON);
	//print $JSON;
	return $JSON;
}

//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------
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
	//print createJSON($iduser);
}
//--------------------------------------------------------------------------------------
function login2($user, $pass) {
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
	
	//REGISTER THE ACTIVITY
	$sql = query("INSERT INTO HISTORYACCESS
				(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
		VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP);"
			, $iduser, $error, $funct);
	
	//successful function
	$result['result'] = array_map('utf8_encode', $SQLuser['result'][0]);
	$result['result']['JSON'] = createJSON2($user);
	
	$m = query(	"SELECT ENGLISH, SPANISH
					FROM ERRORS
					WHERE ERRORCODE=0 LIMIT 1 ");
	
	$result['error']['ENGLISH'] = utf8_encode($m['result'][0]['ENGLISH']);
	$result['error']['SPANISH'] = utf8_encode($m['result'][0]['SPANISH']);
	$result['error']['ERROR'] = 0;
	
	//print count($message['result']).$error;
	
	print json_encode($result);
}
//--------------------------------------------------------------------------------------
function lostpass($user){
/* envia un email al usuario que ha olvidado el password*/
	$error = 0;
	$funct = 2;
	
	switch (testEXIST( 'USERS', 'USERNAME', $user)){
		case 1:	$error = 3;	break;
		case 4:	$error = 4;	break;
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
function createuser2($user, $pass, $email, $hint){
	/* create a new user*/
	$message = query("CALL createuser ('%s','%s', '%s', '%s')", $user, $pass, $email, $hint);
	// take de error message
	
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
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
function deleteuser2($user, $pass){
	/* create a new user*/
	$message = query("CALL deleteuser ('%s', '%s')", $user, $pass);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
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
	$message = query("CALL modifyhouse('%s', '%s', '%s', %s, '%s', '%s')", $user, $house, $n_house, $image, $city, $country);
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
function createaccesshouse($user, $house, $user2, $n){
	/*create access to a house by an administrator <-- user with access number n*/
	$message = query("CALL createaccesshouse('%s', '%s', '%s', %s)",$user, $house, $user2, $n);
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
function addtaskprogram($user, $idtask, $idaction){
	/* create a new user*/
	$message = query("CALL addtaskprogram ('%s','%s','%s')", $user, (int) $idtask, (int) $idaction );
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
function schedulehouse($house){
	/* create a new user*/
	$SQLjson = query("CALL schedule ('%s')",$house);
	// take de error message
	//$json['result'] =  array_map('utf8_encode', $message['result'][0]);
	$num	 = count($SQLjson['result']);
	
	//TEST QUERY HAS AT LEAST one VALUE
	if ($num == 0){
		$JSON = null;
		print json_encode($json);
		return ;
	}
	
	//var for register distinct SOCKET
	$tmpTASKNAME 	= NULL;
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
				
				$JSON["houses"][$h]["name"]   = utf8_encode($SQLjson['result'][$i]['HOUSENAME']);
				$JSON["houses"][$h]["access"] = $SQLjson['result'][$i]['ACCESSNUMBER'];
				
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
				
	roomlabel:	$JSON["houses"][$h]["rooms"][$r]["name"]     = utf8_encode($SQLjson['result'][$i]['ROOMNAME']);
				
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
				
servicelabel:	$JSON["houses"][$h]["rooms"][$r]["services"][$s]["name"]   = utf8_encode($SQLjson['result'][$i]['SERVICENAME']);
				$JSON["houses"][$h]["rooms"][$r]["services"][$s]["id"]     = $SQLjson['result'][$i]['SERVICEINTERFACE'];
				$JSON["houses"][$h]["rooms"][$r]["services"][$s]["access"] = $SQLjson['result'][$i]['PERMISSIONNUMBER'];
				$JSON["houses"][$h]["rooms"][$r]["services"][$s]["state"]  = 1;//servicestate();print 'null';
				
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
	print json_encode($json);
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
		$tipo = $resultado['result'][0]['TYPE'];
		 
		if (count($resultado['result']) <> 0) {
			//ahora colocamos la cabeceras correcta segun el tipo de imagen
			header("Content-type: $tipo");//text/plain");
			echo $imagen;
		}
		else {
			echo 'this image does not exist.';
		}
		//echo '<img src='.$resultado['result'][0]['URL'].' width="100" heigth="100"/>';
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
			// $data = mysql_escape_string($data);
			
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
?>

