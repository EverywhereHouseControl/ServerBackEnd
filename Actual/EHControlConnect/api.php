<?
//API implementation

//--------------------------------------------------------------------------------------
function testNoERROR($iduser, $error, $funct){
	//** TEST NO ERROR AT THIS POINT **
	if ($error <> 0) {
		//REGISTER THE ACTIVITY
		query("INSERT INTO HISTORYACCESS
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
	query("INSERT INTO HISTORYACCESS
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
	query("INSERT INTO USERS
			       (IDUSER, USERNAME, PASSWORD, EMAIL, HINT,     DATEBEGIN)
			VALUES (NULL,      '%s',    '%s',    '%s', '%s', CURRENT_TIMESTAMP)"
			, $user, $pass, $email, $hint);

	//iduser UPDATE FOR NEW USER
	$SQLuser = query("SELECT * FROM USERS WHERE USERNAME='%s' limit 2", $user);
	$iduser  = $SQLuser['result'][0]['IDUSER'];

	//REGISTER THE ACTIVITY
	query("INSERT INTO HISTORYACCESS
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
	query("DELETE FROM USERS
			       WHERE USERNAME='%s'"
			, $user);

	//REGISTER THE ACTIVITY
	query("INSERT INTO HISTORYACCESS
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
	query("UPDATE USERS
				SET USERNAME='%s', PASSWORD='%s', EMAIL='%s', HINT='%s'
			    WHERE USERNAME='%s'"
			, $n_user, $n_pass, $n_email, $n_hint, $user);

	//REGISTER THE ACTIVITY
	query("INSERT INTO HISTORYACCESS
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
		query("INSERT INTO HISTORYACCESS
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
	$host  = $_SERVER['HTTP_HOST'];
	$uri   = rtrim(dirname($_SERVER['PHP_SELF']), '/\\');
	
	$SQLjson = query ( "SELECT *
						FROM  loginVIEW
						WHERE USERNAME = '%s';", $user );
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
				$JSON["houses"][$h]["city"]  = utf8_encode($SQLjson['result'][$i]['CITY']);
				$JSON["houses"][$h]["country"]  =  utf8_encode($SQLjson['result'][$i]['COUNTRY']);
				$JSON["houses"][$h]["weather"] = null;//weatherJSON($SQLjson['result'][$i]['CITY'], $SQLjson['result'][$i]['COUNTRY'], 'en');
				$JSON["houses"][$h]["image"]   = ($SQLjson['result'][$i]['URL'] == NULL) ? NULL:'http://'.$host.$uri.'/'.utf8_encode($SQLjson['result'][$i]['URL']);
				$JSON["houses"][$h]["events"]   = eventJSON(utf8_encode($SQLjson['result'][$i]['HOUSENAME']));
				
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
				$JSON["houses"][$h]["rooms"][$r]["interface"]   = utf8_encode($SQLjson['result'][$i]['ROOMTYPE']);
				
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
	
	//relative path
	$host  = $_SERVER['HTTP_HOST'];
	$uri   = rtrim(dirname($_SERVER['PHP_SELF']), '/\\');
	
	//only for save the iduser becouse we need that
	$SQLuser = query("SELECT IDUSER, USERNAME, PASSWORD, EMAIL, HINT, DATEBEGIN, URL FROM USERS LEFT JOIN IMAGES USING (IDIMAGE) WHERE USERNAME='%s'  limit 2;", $user);
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
	query("INSERT INTO HISTORYACCESS
				(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
		VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP);"
			, $iduser, $error, $funct);
	
	//successful function
	$result['result'] = array_map('utf8_encode', $SQLuser['result'][0]);
	$result['result']['URL'] = ($result['result']['URL'] == NULL)? NULL: 'http://'.$host.$uri.'/'.$result['result']['URL'];
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
	//recovery_mail($email, $user, $pass);
	
	
}

//--------------------------------------------------------------------------------------
function createuser2($user, $pass, $email, $hint){
	/* create a new user*/
	// randomconde verification.
	$codeconfirm = md5(rand(0000000000,9999999999));
	$message = query("CALL createuser ('%s','%s', '%s', '%s', '%s'); ", $user, $pass, $email, $hint, $codeconfirm);
	// take de error message
	
	//**confirm message deleted
	$sqlregistration = query ( "SELECT * FROM REGISTRATIONS WHERE CODECONFIRM = '%s' limit 1;", $codeconfirm );
	
	query ( "DELETE FROM REGISTRATIONS WHERE CODECONFIRM = '%s' LIMIT 1;", $codeconfirm );
	query ( "INSERT INTO `USERS` (`IDUSER`, `USERNAME`, `PASSWORD`, `EMAIL`, `HINT`, `IDIMAGE`, `DATEBEGIN`) VALUES
									(NULL, '%s', '%s', '%s', '%s', NULL, '%s');",
										$sqlregistration ['result'][0]['USERNAME'],
										$sqlregistration ['result'][0]['PASSWORD'],
										$sqlregistration ['result'][0]['EMAIL'],
										$sqlregistration ['result'][0]['HINT'],
										$sqlregistration ['result'][0]['DATEBEGIN']);
		
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	if ($json['error']['ERROR'] == 0){
		//confirm_mail($email, $user, $codeconfirm);
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
		//goodbye_mail($email, $user);
	}
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function modifyuser2($user, $pass, $n_user, $n_pass, $n_email, $n_hint, $image){
	/* create a new user*/
	$message = query("CALL modifyuser ('%s','%s','%s','%s','%s','%s','%s')", $user, $pass, $n_user, $n_pass, $n_email, $n_hint, $image);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function doaction($user,$house,$room,$service,$action,$data) {
/* a user send a specific action aobut a service with or without data*/
	$error = 0;
	$funct = 6;
	
	$SQLdoaction = query("SELECT * 
			FROM loginVIEW 
			WHERE   USERNAME    ='%s'
				AND HOUSENAME   ='%s'
				AND ROOMNAME    ='%s'
				AND SERVICENAME ='%s' 
				AND ACTIONNAME  ='%s'   limit 2", $user,$house,$room,$service,$action );
	$iduser  = $SQLdoaction['result'][0]['IDUSER'];
	$num	 = count($SQLdoaction['result']);
	switch ($num){
		case 0:	$error =11;	break;
		case 2:	$error = 4;	break;
	}
	
	testNoERROR($iduser, $error, $funct);
	
	//TEST HAVE ACCESS or PERMISSION
	if ($SQLdoaction['result'][0]['ACCESSNUMBER'] != 1) {
		if ($SQLdoaction['result'][0]['PERMISSIONNUMBER'] != 1) {
			$error = 10;
		}
		else{
			$error = 39;
		}
	}
	
	//http conection
	$ipaddress = $SQLdoaction['result'][0]['IPADDRESS'];
	
	//construction code to raspberry would be send
	$raspberryiddevice = $SQLdoaction['result'][0]['IDDEVICE'];
	$raspberryidservice = $SQLdoaction['result'][0]['IDSERVICE'];
	//$raspberryaction = $SQLdoaction['result'][0]['ACTIONNAME'];
	
	//GET THE FUNCTION TYPE
	$FCODE = $SQLdoaction['result'][0]['FCODE'];
	$TYPE  = $SQLdoaction['result'][0]['TYPE'];

	switch ($FCODE){
		case 'IRCODES':
			//GET THE IRCODE CODE
			$code = query("SELECT  %s
					   FROM   IRCODES
					   WHERE  TYPE='%s' limit 2", $data, $TYPE);
			$num	 = count($code['result']);
			
			//TEST BOTTON EXIST
			$error = ($code['result'][0][$data] == NULL)?68:0;
			switch ($num){
				case 0:	$error = 68;break;
				case 2:	$error = 4;	break;
			}
			
			testNoERROR($iduser, $error, $funct);
			
			$raspberryaction = $code['result'][0][$data];
			break;
			
		case 'OPEN/CLOSE':
			switch ($data){
				case 'OPEN':
					$raspberryaction = '1';
					break;
				case 'CLOSE':
					$raspberryaction = '0';
					break;
				default:
					$raspberryaction = '';
			}
			break;
			
		case 'ON/OFF':	
			switch ($data){
				case 'ON':
					$raspberryaction = '0';
					break;
				case 'OFF':
					$raspberryaction = '0';
					break;
				default:
					$raspberryaction = '';
			}
			break;
			
		case 'UP/MEDIUM/DOWN':
			switch ($data){
				case 'UP':
					$raspberryaction = '2';
					break;
				case 'MEDIUM':
					$raspberryaction = '1';
					break;
				case 'DOWN':
					$raspberryaction = '0';
					break;
				default:
					$raspberryaction = '';
			}
			break;
		default:
			$raspberry .= '-';
	}
	
	//SEND ENCODE ACTION TO THE RASPBERRY-ARDUINO SISTEM  $IRCODE.$FCODE;
	header("Location: $ipaddress?command=SEND&iddevice=$raspberryiddevice&idservice=$raspberryidservice&action=$raspberryaction&data=0");
	//header("Location: http://ehcontrol.net/EHControlConnect/");
	//echo "<a href='$ipaddress?valor=$raspberry'></a>";
	
	
	//REGISTER ARDUINO ANSWER
	query("INSERT INTO HISTORYACTION
						(`IDHISTORYACTION`, `IDACTION`, `IDPROGRAM`, `IDUSER`, `RETURNCODE`, `DATESTAMP`)
				VALUES  (NULL,                '%s',      NULL,           '%s',  '%s',  CURRENT_TIMESTAMP)"
			, $idaction, $iduser, $IRCODE.$FCODE);	

	//REGISTER THE ACTIVITY
	query("INSERT INTO HISTORYACCESS
				(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
		VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP)"
			, $iduser, $error, $funct);
	
	// take de error message
	/*$error = 16;//acction sent
	message($error, 0);*/
	
	

}

//--------------------------------------------------------------------------------------
function ipcheck(){
/* Returs Real Client IP */
	$error = 0;
	$funct = 8;
	$iduser = 0;//administrator
	
	//REGISTER THE ACTIVITY
	query("INSERT INTO HISTORYACCESS
				(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
		VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP)"
			, $iduser, $error, $funct);
	
	print json_encode ($_SERVER['REMOTE_ADDR']);
	exit();
}

//--------------------------------------------------------------------------------------
function getweather($city, $country, $language){
/* returns the weather of a specific city and country */
	$error = 0;
	$funct = 10;
	$iduser = 0;//administrator
	
	//REGISTER THE ACTIVITY
	query("INSERT INTO HISTORYACCESS
				(IDHISTORY, IDUSER, IDHOUSE, ERROR, FUNCT, DATESTAMP        )
		VALUES  (     NULL,   '%s',    NULL,  '%s',  '%s', CURRENT_TIMESTAMP)"
			, $iduser, $error, $funct);
	
	//exec('./clima ' .$city.' '. $language,$output);
	
	$language = ($language == null || $language == '')? 'en':$language;
	exec('./clima '.$city.','.$country.' '. $language,$output);
	//$salida=json_encode ($output);
	//$s=json_decode($json);
	
	/*foreach($s as &$valor){
		echo ($valor);
		echo ("heheheh\n");
	}*/
	//$value = $output;
	//$sal = $json->encode($value);
	//print json_encode($sal);
	//$quitar = array("/" => "2", "<br />" => "", "<br>" => "", "<br >" => "");
	//foreach($salida as $busca => $quita){
	//	$data["content"] = str_replace($busca, $quita, $data["content"]);
	//}
	//print json_encode($output);
	print $output[0];
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
	
	$dir = 'images/'.$house;
	mkdir($dir, 0777);
	
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function modifyhouse($user, $house, $n_house, $image, $city, $country){
	/* modify information of house by an administrator*/
	$image = str_replace(" ", "", $image);
	$message = query("CALL modifyhouse('%s', '%s', '%s', '%s', '%s', '%s')", $user, $house, $n_house, $image, $city, $country);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}
//--------------------------------------------------------------------------------------
// recursively remove a directory
function rrmdir($dir) {
	foreach(glob($dir . '/*') as $file) {
		if(is_dir($file))
			rrmdir($file);
		else
			unlink($file);
	}
	rmdir($dir);
}
//--------------------------------------------------------------------------------------
function deletehouse($user, $pass, $house){
	/*delete a existing house by an administrator user <-- user with access number 1*/
	$message = query("CALL deletehouse('%s', '%s', '%s')", $user, $pass, $house);
	
	$dir = 'images/'.$house;
	rrmdir($dir);
	
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
function modifyservicetype($user, $iddevice, $service, $type){
	/* */
	$message = query("CALL modifyservicetype('%s', %s, '%s', '%s')", $user, (int) $iddevice, $service, $type);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function createpermissionservice($user, $house, $room, $service, $user2, $n){
	/* */
	$message = query("CALL createpermissionservice('%s', '%s', '%s', '%s', '%s', %s)", $user, $house, $room, $service, $user2, (int) $n);
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function deletepermissionservice($user, $house, $room, $service, $user2){
	/* */
	$message = query("CALL deletepermissionservice('%s', '%s', '%s', '%s', '%s')", $user, $house, $room, $service, $user2);
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
function createprogramaction($name, $user, $house, $room, $service, $action, $data, $start){
	/* create a new user*/
	$message = query("CALL createprogramaction ('%s','%s','%s','%s','%s','%s','%s','%s', CURRENT_TIMESTAMP)", $name, $user, $house, $room, $service, $action, $data, date("Y-m-d H:i:s",strtotime($start)) );
	// take de error message
	$json['error'] =  array_map('utf8_encode', $message['result'][0]);
	print json_encode($json);
}

//--------------------------------------------------------------------------------------
function deleteprogramaction($user, $name){
	/* create a new user*/
	$message = query("CALL deleteprogramaction ('%s','%s')", $user, $name);
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
function eventJSON($house){

	$SQLjson = query ( "SELECT *
						FROM eventProgramVIEW
						WHERE HOUSENAME = '%s' ;", $house );
	$num	 = count($SQLjson['result']);
//print $house.' '.$num.'  ';
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
				$ev = 'Event'.$p;

	roomlabel:	$JSON[$ev]["Name"]     = $SQLjson['result'][$i]['PROGRAMNAME'];
				$JSON[$ev]["item"]     = $SQLjson['result'][$i]['IDSERVICE'];
				$JSON[$ev]["house"]    = $SQLjson['result'][$i]['HOUSENAME'];
				$JSON[$ev]["room"]     = $SQLjson['result'][$i]['ROOMNAME'];
				$JSON[$ev]["service"]  = $SQLjson['result'][$i]['SERVICENAME'];
				$JSON[$ev]["action"]   = $SQLjson['result'][$i]['ACTIONNAME'];
				$JSON[$ev]["data"]     = $SQLjson['result'][$i]['DATA'];
				//$JSON[$ev]["starttime"]   = date("Y-m-d H:i:s", strtotime($SQLjson['result'][$i]['STARTTIME']));
				$JSON[$ev]["Day"]   = date("d", strtotime($SQLjson['result'][$i]['STARTTIME']));
				$JSON[$ev]["Month"] = date("m", strtotime($SQLjson['result'][$i]['STARTTIME']));
				$JSON[$ev]["Year"]  = date("Y", strtotime($SQLjson['result'][$i]['STARTTIME']));
				$JSON[$ev]["Hour"]  = date("H", strtotime($SQLjson['result'][$i]['STARTTIME']));
				$JSON[$ev]["Minute"]= date("i", strtotime($SQLjson['result'][$i]['STARTTIME']));
				$JSON[$ev]["Second"]= date("s", strtotime($SQLjson['result'][$i]['STARTTIME']));
				$JSON[$ev]["Created"]= $SQLjson['result'][$i]['USERNAME'];
					
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
	$image = str_replace(" ", "", $image);
	$destino = 'images/'.$image;
	if (copy($ruta,$destino)) {
		$return['error']['ERROR'] = 0;
		$return['error']['ENGLISH'] = "Uploaded image.";
		$return['error']['SPANISH'] = "Archivo subido.";
	} else {
		$return['error']['ERROR'] = 1;
		$return['error']['ENGLISH'] = "Error on update image.";
		$return['error']['SPANISH'] = "Error al subir archivo.";
		
	}
	query ( "INSERT INTO IMAGES (IDIMAGE, URL, TYPE) 
									VALUES   (NULL, '%s', '%s')", $destino, $tipo);
	
	print json_encode($return);
}
//--------------------------------------------------------------------------------------
function confirm_mail($email, $user, $codeconfirm){
	//relative path
	$host  = $_SERVER['HTTP_HOST'];
	$uri   = rtrim(dirname($_SERVER['PHP_SELF']), '/\\');
	
	//header html mail
	$mail_headers="MIME-Version: 1.0\r\n";
	$mail_headers.="Content-type: text/html; charset=iso-8859-1\r\n";
	
	//header remiter
	$mail_headers.="From: EHC<no-response@ehc.com>";
	
	$mail_message ='
		<h1 class="Text" style="position: absolute; left: 24px; top: 215px; width: 460px; height: 26px;"><span style="font-family: comic sans ms,sans-serif; font-size: x-large; color: #333399;"><span class="hps">Confirm EHC account.</span></span></h1>
		<p style="left: 65px; top: 1px; width: 202px; height: 202px; position: absolute;"><img style="display: block; margin-left: auto; margin-right: auto; top: 1px; left: 14px; width: 205px; height: 205px;" src="http://'.$host.$uri.'/images/logo.png" alt="" /></p>
		<div style="position: absolute; left: 24px; top: 262px; width: 444px; height: 100px;">
		<p><span style="font-family: verdana,geneva; font-size: medium;"> '.$user.', confirm your EHC account clicking on below or copying that on your browser.</span></p>
		<span style="font-family: verdana,geneva; font-size: medium;"> http://'.$host.$uri.'/confirm.php?code='.$codeconfirm.'</span></div>';
	
	mail($email, "CONFIRM EHC", $mail_message, $mail_headers);
}
//--------------------------------------------------------------------------------------
function welcome_mail($email, $user){
	//relative path
	$host  = $_SERVER['HTTP_HOST'];
	$uri   = rtrim(dirname($_SERVER['PHP_SELF']), '/\\');
	
	//header html mail
	$mail_headers="MIME-Version: 1.0\r\n";
	$mail_headers.="Content-type: text/html; charset=iso-8859-1\r\n";

	//header remiter
	$mail_headers.="From: EHC<no-response@ehc.com>";

	$mail_message ='
		<h1 class="Text" style="position: absolute; left: 24px; top: 215px; width: 460px; height: 26px;"><span style="font-family: comic sans ms,sans-serif; font-size: x-large; color: #333399;"><span class="hps">Welcome to EHC.</span></span></h1>
		<p style="left: 65px; top: 1px; width: 202px; height: 202px; position: absolute;"><img style="display: block; margin-left: auto; margin-right: auto; top: 1px; left: 14px; width: 205px; height: 205px;" src="http://'.$host.$uri.'/images/logo.png" alt="" /></p>
		<div style="position: absolute; left: 24px; top: 262px; width: 444px; height: 100px;">
		<p><span style="font-family: verdana,geneva; font-size: medium;">Congratulations! '.$user.' from now, you will experience the comfort about the mobile control of EHC.</span></p>
		<span style="font-family: verdana,geneva; font-size: medium;"> Hope you like.</span></div>';

	mail($email, "WELCOME EHC!", $mail_message, $mail_headers);
}
//--------------------------------------------------------------------------------------
function goodbye_mail($email,$user){
	//relative path
	$host  = $_SERVER['HTTP_HOST'];
	$uri   = rtrim(dirname($_SERVER['PHP_SELF']), '/\\');
	
	//header html mail
	$mail_headers="MIME-Version: 1.0\r\n";
	$mail_headers.="Content-type: text/html; charset=iso-8859-1\r\n";
	
	//header remiter
	$mail_headers.="From: EHC<no-response@ehc.com>";
	
	$mail_message ='
		<h1 class="Text" style="position: absolute; left: 24px; top: 215px; width: 460px; height: 26px;"><span style="font-family: comic sans ms,sans-serif; font-size: x-large; color: #333399;"><span class="hps">Account deleted.</span></span></h1>
		<p style="left: 65px; top: 1px; width: 202px; height: 202px; position: absolute;"><img style="display: block; margin-left: auto; margin-right: auto; top: 1px; left: 14px; width: 205px; height: 205px;" src="http://'.$host.$uri.'/images/logo.png" alt="" /></p>
		<div style="position: absolute; left: 24px; top: 262px; width: 444px; height: 100px;">
		<p><span style="font-family: verdana,geneva; font-size: medium;">Good Bye! '.$user.', see you soon.</span></p>
		<span style="font-family: verdana,geneva; font-size: medium;"> EHC.</span></div>';
	
	mail($email, "GOOD BYE! from EHC", $mail_message, $mail_headers);
}
//--------------------------------------------------------------------------------------
function recovery_mail($email, $user, $pass){
	//relative path
	$host  = $_SERVER['HTTP_HOST'];
	$uri   = rtrim(dirname($_SERVER['PHP_SELF']), '/\\');
	
	//header html mail
	$mail_headers="MIME-Version: 1.0\r\n";
	$mail_headers.="Content-type: text/html; charset=iso-8859-1\r\n";
	
	//header remiter
	$mail_headers.="From: EHC<no-response@ehc.com>";
	
	$mail_message = '
			<h1 class="Text" style="position: absolute; left: 24px; top: 215px; width: 460px; height: 26px;"><span style="font-family: comic sans ms,sans-serif; font-size: x-large; color: #333399;"><span class="hps">Email</span> <span class="hps">password</span> <span class="hps">recovery</span>.</span></h1>
			<p style="left: 65px; top: 1px; width: 202px; height: 202px; position: absolute;"><img style="display: block; margin-left: auto; margin-right: auto; top: 1px; left: 14px; width: 205px; height: 205px;" src="http://'.$host.$uri.'/images/logo.png" alt="" /></p>
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

