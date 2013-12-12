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

function creategame($idus,$usname,$idco,$coname,$icon1,$icon2, $lang) {
    $tiempo = date("Y-m-d H:i:s");
	$estrellas1 = "0*0*0*0*0";
	$estrellas2 = "0*0*0*0*0";
    $result = query("INSERT INTO games(IdPlayer1, namePlayer1, IdPlayer2, namePlayer2, stars1, stars2, hayReto1, hayReto2, retoAcertadas1, retoAcertadas2, preguntaReto1, preguntaReto2, preguntaReto3, preguntaReto4, preguntaReto5, pos1, pos2, time, turno, icono1, icono2, language) VALUES('%s','%s','%s','%s','%s','%s',0,0,0,0,0,0,0,0,0,7,19,'%s',0,'%s','%s','%s')", $idus, $usname, $idco, $coname, $estrellas1, $estrellas2, $tiempo, $icon1, $icon2, $lang);
    if (!$result['error']) {
        //success
    } else {
        //error
        errorJson('Create Game Failed');
    }

}

function guardaramigo($idus,$coname,$idco,$ico1,$ico2) {
    
    $result = query("SELECT * FROM amigos WHERE IdUser='%s' AND amigo='%s' AND IdAmigo='%s'",$idus,$coname,$idco);
    
    if (count($result['result'])>0) {
        errorJson('Friend yet agree');
    }
    else{
    
        $result = query("INSERT INTO amigos(IdUser, amigo, IdAmigo, icono1, icono2) VALUES('%s','%s','%s','%s','%s')", $idus, $coname, $idco, $ico1, $ico2);
        if (!$result['error']) {
            //success
        } else {
            //error
            errorJson('Save Friend Failed');
        }
    }
}

function getamigos($id) {
    
    $result = query("SELECT * FROM amigos WHERE IdUser='%s'", $id);
    
    if (count($result['result'])>0) {
        //authorized
        //	 $_SESSION['IdUser'] = $result['result'][0]['IdUser'];
        print json_encode($result);
    } else {
        //not authorized
        errorJson('Get Amigos failed');
    }
    
}

function actualizarPartida($idgame,$turno,$star1,$star2,$pos1,$pos2) {
    $tiempo = date("Y-m-d H:i:s");
    $result = query("UPDATE games SET turno='%s',stars1='%s', stars2='%s', pos1='%s',pos2='%s',time='%s' WHERE IdGame='%s'",$turno,$star1,$star2,$pos1,$pos2,$tiempo,$idgame);
    
     if ($result == TRUE) {
        //authorized
        //	 $_SESSION['IdUser'] = $result['result'][0]['IdUser'];
        print json_encode($result);
    } else {
        //not authorized
        errorJson('Actualization failed');
    }
}

function actualizarPartidaFinal($idgame,$turno,$star1,$star2) {
    
    $result = query("UPDATE games SET turno='%s',stars1='%s', stars2='%s' WHERE IdGame='%s'",$turno,$star1,$star2);
    
     if ($result == TRUE) {
        //authorized
        //	 $_SESSION['IdUser'] = $result['result'][0]['IdUser'];
        print json_encode($result);
    } else {
        //not authorized
        errorJson('Actualization failed');
    }
}

function actualizarPartidaReto($idgame,$turno,$star1,$star2,$hayReto1,$hayReto2,$acertadasReto1,$acertadasReto2,$pregunta1,$pregunta2,$pregunta3,$pregunta4,$pregunta5,$pos1,$pos2) {
    
    $result = query("UPDATE games SET turno='%s',stars1='%s', stars2='%s', hayReto1='%s', hayReto2='%s', retoAcertadas1='%s', retoAcertadas2='%s',preguntaReto1='%s' ,preguntaReto2='%s' ,preguntaReto3='%s' ,preguntaReto4='%s' ,preguntaReto5='%s', pos1='%s',pos2='%s' WHERE IdGame='%s'",$turno,$star1,$star2,$hayReto1, $hayReto2,$acertadasReto1,$acertadasReto2,$pregunta1,$pregunta2,$pregunta3,$pregunta4,$pregunta5,$pos1,$pos2,$idgame);
    
     if ($result == TRUE) {
        //authorized
        //	 $_SESSION['IdUser'] = $result['result'][0]['IdUser'];
        print json_encode($result);
    } else {
        //not authorized
        errorJson('Actualization failed');
    }
}

function actualizarTurno($idgame,$turno){
	$result = query("UPDATE games SET turno='%s' WHERE IdGame='%s'",$turno,$idgame);
    
     if ($result == TRUE) {
        //authorized
        //	 $_SESSION['IdUser'] = $result['result'][0]['IdUser'];
        print json_encode($result);
    } else {
        //not authorized
        errorJson('Actualization failed');
    }
}

function borrarPartida($idgame){
	$result = query("DELETE FROM games WHERE IdGame='%s'",$idgame);
    
     if ($result == TRUE) {
        //authorized
        //	 $_SESSION['IdUser'] = $result['result'][0]['IdUser'];
        print json_encode($result);
    } else {
        //not authorized
        errorJson('Actualization failed');
    }
}

function actualizarPreguntas($iduser,$fichas,$level,$levelCont,$points,$pregCom,$pregMis,$pregPol,$pregCien,$pregClas,$estadis){
	$result = query("UPDATE login SET fichas='%s',level='%s',levelCont='%s',points='%s',preguntaComedia='%s',preguntaMiscelanea='%s',preguntaPoliciacas='%s',preguntaCienciaFiccion='%s',preguntaClasicas='%s',estadisticas='%s' WHERE IdUser='%s'",$fichas,$level,$levelCont,$points,$pregCom,$pregMis,$pregPol,$pregCien,$pregClas,$estadis,$iduser);
    
     if ($result == TRUE) {
        //authorized
        //	 $_SESSION['IdUser'] = $result['result'][0]['IdUser'];
        print json_encode($result);
    } else {
        //not authorized
        errorJson('Actualization failed');
    }
}

function cambiarEmail($IdUser,$pass,$newEmail){

		$result = query("UPDATE login SET email='%s' WHERE IdUser='%s' AND pass='%s'",$newEmail,$IdUser,$pass);
    
		if ($result == TRUE) {
			//authorized
			//	 $_SESSION['IdUser'] = $result['result'][0]['IdUser'];
			print json_encode($result);
		} else {
			//not authorized
			errorJson('Actualization failed');
		}
}
		

function cambiarPwd($IdUser,$pass,$pwdNueva){
		$result = query("UPDATE login SET pass='%s' WHERE IdUser='%s' AND pass='%s'",$pwdNueva,$IdUser,$pass);
    
			 if ($result == TRUE) {
				//authorized
				//	 $_SESSION['IdUser'] = $result['result'][0]['IdUser'];
				print json_encode($result);
			} else {
				//not authorized
				errorJson('Actualization failed');
			}
}

function cambiarFicha1($IdUser,$ficha1){
		$result = query("UPDATE login SET ficha1='%s' WHERE IdUser='%s'",$ficha1,$IdUser);
    
			 if ($result == TRUE) {
				//authorized
				//	 $_SESSION['IdUser'] = $result['result'][0]['IdUser'];
				print json_encode($result);
			} else {
				//not authorized
				errorJson('Actualization failed');
			}
}

function cambiarFicha2($IdUser,$ficha2){
		$result = query("UPDATE login SET ficha2='%s' WHERE IdUser='%s'",$ficha2,$IdUser);
    
			 if ($result == TRUE) {
				//authorized
				//	 $_SESSION['IdUser'] = $result['result'][0]['IdUser'];
				print json_encode($result);
			} else {
				//not authorized
				errorJson('Actualization failed');
			}
}

function quitarPubli($IdUser,$publi){
		$result = query("UPDATE login SET publi='%s' WHERE IdUser='%s'",$publi,$IdUser);
   // UPDATE ranking SET idUser,user,level,points SELECT IdUser,username,level,points FROM `login` WHERE (`level` < 11) ORDER BY `level` DESC, `points` DESC
			 if ($result == TRUE) {
				//authorized
				//	 $_SESSION['IdUser'] = $result['result'][0]['IdUser'];
				print json_encode($result);
			} else {
				//not authorized
				errorJson('Actualization failed');
			}
}

function actualizarTablaR(){
		$result = query("SELECT IdUser,username,level,points,ficha1 FROM `login` WHERE (`level` < 11) ORDER BY `level` DESC, `points` DESC");
		
		$i = 0;
		while($i < count($result['result'])){
			$IdUser = $result['result'][$i]['IdUser'];
			$user = $result['result'][$i]['username'];;
			$level = $result['result'][$i]['level'];;
			$points = $result['result'][$i]['points'];;
			$ficha = $result['result'][$i]['ficha1'];;
			$result2 = query("UPDATE ranking SET idUser='%s', user='%s', level='%s', points='%s', ficha='%s' WHERE id='%s'",$IdUser,$user,$level,$points,$ficha,$i+1);
			$i++;
			}
    
			 if ($result2 == TRUE) {
			//authorized
			//	 $_SESSION['IdUser'] = $result['result'][0]['IdUser'];
			print json_encode($result2);
			} else {
			//not authorized
			errorJson('Actualization failed');
			}
}

function getRanking(){
		$result = query("SELECT * FROM `ranking` limit 50");
    
		if (count($result['result'])>0) {
        	//authorized
        
        	print json_encode($result);
    	} else {
        	errorJson('Searching failed');//'Searching failed'
    	}
}

function guardarCompra($IdUser,$fichas,$points){
		$result = query("UPDATE login SET fichas='%s', points='%s' WHERE IdUser='%s'",$fichas,$points,$IdUser);
    
			 if ($result == TRUE) {
				//authorized
				//	 $_SESSION['IdUser'] = $result['result'][0]['IdUser'];
				print json_encode($result);
			} else {
				//not authorized
				errorJson('Actualization failed');
			}
}
?>