<?
session_start();
require("lib.php");
require("api.php");

header("Content-Type: application/json");

//API
switch ($_POST['command']) {
	case "login":
		login($_POST['username'], $_POST['password']); break;
    
	case "logout":
		logout(); sbreak;
	
	case "register":
		register($_POST['username'], $_POST['password'], $_POST['email'], $_POST['ficha1'], $_POST['ficha2']); break;
		
    case "getusers":
        getusers($_POST['username'],$_POST['usernameUser']); break;
        
	case "getuserAl":
        getuserAl($_POST['IdUser']); break;
		
    case "getgame":
        getgame($_SESSION['IdUser']); break;
        
    case "getthisgame":
        getthisgame($_POST['IdGame']); break;
        
    case "creategame":
        creategame($_POST['iduser'],$_POST['username'],$_POST['idcon'],$_POST['contriname'],$_POST['icono1'],$_POST['icono2'],$_POST['language']); break;
    
    case "guardaramigo":
        guardaramigo($_POST['iduser'],$_POST['contriname'],$_POST['idcon'],$_POST['icono1'],$_POST['icono2']); break;
		
    case "getamigos":
        getamigos($_SESSION['IdUser']); break;
	
	case "actualizarPartida":
		actualizarPartida($_POST['IdGame'],$_POST['turno'],$_POST['stars1'],$_POST['stars2'],$_POST['pos1'],$_POST['pos2']); break;
		
		case "actualizarPartidaFinal":
		actualizarPartida($_POST['IdGame'],$_POST['turno'],$_POST['stars1'],$_POST['star1Comedia'],$_POST['star1Miscelanea'],$_POST['star1Policiacas'],$_POST['star1CienciaFiccion'],$_POST['star1Clasicas'],$_POST['stars2'],$_POST['star2Comedia'],$_POST['star2Miscelanea'],$_POST['star2Policiacas'],$_POST['star2CienciaFiccion'],$_POST['star2Clasicas'],$_POST['pos1'],$_POST['pos2'],$_POST['turno']); break;
		
	case "actualizarPartidaReto":
		actualizarPartidaReto($_POST['IdGame'],$_POST['turno'],$_POST['stars1'],$_POST['stars2'],$_POST['hayReto1'],$_POST['hayReto2'],$_POST['retoAcertadas1'],$_POST['retoAcertadas2'],$_POST['preguntaReto1'],$_POST['preguntaReto2'],$_POST['preguntaReto3'],$_POST['preguntaReto4'],$_POST['preguntaReto5'],$_POST['pos1'],$_POST['pos2']); break;

	case "actualizarTurno":
		actualizarTurno($_POST['IdGame'],$_POST['turno']); break;
		
	case "borrarPartida":
		borrarPartida($_POST['IdGame']); break;
		
	case "actualizarPreguntas":
		actualizarPreguntas($_POST['IdUser'],$_POST['fichas'],$_POST['level'],$_POST['levelCont'],$_POST['points'],$_POST['preguntaComedia'],$_POST['preguntaMiscelanea'],$_POST['preguntaPoliciacas'],$_POST['preguntaCienciaFiccion'],$_POST['preguntaClasicas'],$_POST['estadisticas']); break;
	
	case "cambiarEmail":
		cambiarEmail($_POST['IdUser'],$_POST['pass'],$_POST['newEmail']); break;
		
	case "cambiarPwd":
		cambiarPwd($_POST['IdUser'],$_POST['pass'],$_POST['pwdNueva']); break;
		
	case "cambiarFicha1":
		cambiarFicha1($_POST['IdUser'],$_POST['ficha1']); break;
	
	case "cambiarFicha2":
		cambiarFicha2($_POST['IdUser'],$_POST['ficha2']); break;
		
	case "quitarPubli":
		quitarPubli($_POST['IdUser'],$_POST['publi']); break;
		
	case "ranking":
		actualizarTablaR(); break;
		
	case "getRanking":
	 	getRanking(); break;
		
	case "guardarCompra":
		guardarCompra($_POST['IdUser'],$_POST['fichas'],$_POST['points']); break;
}

exit();
?>