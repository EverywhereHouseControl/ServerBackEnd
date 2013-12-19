<?
//API implementation to come here

function errorJson($msg){
	print json_encode(array('error'=>$msg));
	exit();
}

function register($user, $pass, $mail, $f1, $f2) {
	//check if username exists
	$login = query("SELECT username FROM login WHERE username='%s' limit 1", $user);
	if (count($login['result'])>0) {
		errorJson('Username already exists');
	}
    else{
    	//try to register the user
    	$result = query("INSERT INTO login(username, pass, email, ficha1, ficha2) VALUES('%s','%s','%s','%s','%s')", $user, $pass, $mail ,$f1, $f2);
    	if (!$result['error']) {
        	//success
        	login($user, $pass);
    	} else {
        	//error
        	errorJson('Registration failed');
    	}
	}
}

function login($user, $pass) {
	$result = query("SELECT * FROM login WHERE username='%s' AND pass='%s' limit 1", $user, $pass);
	if (count($result['result'])>0) {
		//authorized
		$_SESSION['IdUser'] = $result['result'][0]['IdUser'];
		print json_encode($result);
	} else {
		//not authorized
		errorJson('Authorization failed');
	}
}

function logout(){
	session_destroy();	
}

function getusers($user,$userUsuario) {
	$userAux = "%" . $user . "%";
    $result = query("SELECT IdUser, username, ficha1, ficha2 FROM login WHERE username!='%s' AND username LIKE '%s'",$userUsuario,$userAux);
	   //"SELECT IdUser, username FROM login WHERE username LIKE %victor%",$user);  username!='%s' AND ,$userUsuario
    if (count($result['result'])>0) {
        //authorized
        
        print json_encode($result);
    } else {
        errorJson('Searching failed');//'Searching failed'
    }
}

function getuserAl($user) {
	$tiempo = date("Y-m-d H:i:s");
    $result = query("SELECT IdUser, username, ficha1, ficha2 FROM login WHERE 	TIMESTAMPDIFF(MINUTE,'%s', ultAcceso)<120 AND IdUser!='%s' LIMIT 1",$tiempo,$user);
	   //"SELECT IdUser, username FROM login WHERE username LIKE %victor%",$user);
    if (count($result['result'])>0) {
        //authorized
        print json_encode($result);
    } else {
		$aleatorio = rand(1,8);
		while($aleatorio == intval($user)){
			$aleatorio = rand(1,8);	
		}
		$result = query("SELECT IdUser, username, ficha1, ficha2 FROM login WHERE IdUser='%s' LIMIT 1",$aleatorio);
		if(count($result['result'])>0){
			//authorized
	        print json_encode($result);
		}
		else{
	        errorJson('Searching failed');
		}
	}
}

function getgame($id) {
    
    if(!$id) errorJson('Authorization required');
    
    $result = query("SELECT IdGame, IdPlayer1, namePlayer1, IdPlayer2, namePlayer2, stars1, stars2, pos1, pos2, time, turno, icono1, icono2, language FROM games WHERE IdPlayer1='%s' OR IdPlayer2='%s'",$id, $id);
	
 //   $tiempo = new DateTime(date("Y-m-d H:i:s"));
	$tiempo = date("Y-m-d H:i:s");
//	$vartiempo = array('time'=>$tiempo);
//	array_push($result,$vartiempo);
	foreach($result['result'] as &$valor){
		$interval = strtotime($tiempo) - strtotime($valor['time']);
		$diferencia = intval($interval/60);
//		$nuevafech = date_format($interval,"Y-m-d H:i:s");
		$valor['time'] = strval($diferencia);
	}
	query("UPDATE login SET ultAcceso='%s' WHERE IdUser='%s'",$tiempo,$id);
    if (count($result['result'])>0) {
        //authorized$result = query("SELECT IdGame, IdPlayer1, namePlayer1, IdPlayer2, namePlayer2, stars1, stars2, pos1, pos2, time, turno, icono1, icono2, language, estadisticas.* FROM games, estadisticas WHERE games.IdPlayer1='%s' OR games.IdPlayer2='%s' AND estadisticas.idUser='%s'",$id, $id, $id);
        	 
        print json_encode($result);
    } else {
        //not authorized
        errorJson('Actualization failed');
    }
}

function getthisgame($idgame) {
    
    $result = query("SELECT IdGame, IdPlayer1, namePlayer1, IdPlayer2, namePlayer2, stars1, stars2, hayReto1, hayReto2, retoAcertadas1, retoAcertadas2, preguntaReto1, preguntaReto2, preguntaReto3, preguntaReto4, preguntaReto5, pos1, pos2, time, turno, icono1, icono2, language FROM games WHERE IdGame='%s'", $idgame);
    
    if (count($result['result'])>0) {
        //authorized
        //	 $_SESSION['IdUser'] = $result['result'][0]['IdUser'];
        print json_encode($result);
    } else {
        //not authorized
        errorJson('Charged Game Failed');
    }
}
}
?>