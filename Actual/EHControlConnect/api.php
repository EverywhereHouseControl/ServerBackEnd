<?
//API implementation to come here

function errorJson($msg){
	print json_encode(array('error'=>$msg));
	exit();
}

function login($user, $pass) {
	$result = query("SELECT * FROM login WHERE username='%s' AND password='%s' limit 1", $user, $pass);
	if (count($result['result'])>0) {
		//authorized
		$_SESSION['IdUser'] = $result['result'][0]['IdUser'];
		print json_encode($result);
	} else {
		//not authorized
		errorJson('Authorization failed');
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

?>
