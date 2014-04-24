<?
     /* A continuación, realizamos la conexión con nuestra base de datos en MySQL */
	 #Los datos de acceso:

	$hostname = "localhost";
	$usuario = "alex";
	$password = "alex";
	$basededatos = "devPreview";
	$tabla = "login";

	#Conectando con MySQL
	$idconnect=mysql_connect("$hostname", "$usuario", "$password");
    $dbconnect = mysql_select_db("$basededatos",$idconnect);
	/* El query valida si el usuario ingresado existe en la base de datos. Se utiliza la función 
     htmlentities para evitar inyecciones SQL. */
     $myusuario = mysql_query("SELECT IdUser FROM login WHERE username = '".htmlentities($_POST["usuario"])."'",$idconnect);
     $nmyusuario = mysql_num_rows($myusuario);

     //Si existe el usuario, validamos también la contraseña ingresada y el estado del usuario...
     if($nmyusuario != 0){
	 
          $sql = "SELECT username FROM login WHERE username = '".htmlentities($_POST["usuario"])."' AND password = '".md5(htmlentities($_POST["clave"]))."'";
          $myclave = mysql_query($sql,$idconnect);
          $nmyclave = mysql_num_rows($myclave);
          //Si el usuario y clave ingresado son correctos (y el usuario está activo en la BD), creamos la sesión del mismo.
          if($nmyclave != 0){
               session_start();
               //Guardamos dos variables de sesión que nos auxiliará para saber si se está o no "logueado" un usuario
               $_SESSION["autentica"] = "SIP";
               $_SESSION["usuarioactual"] = mysql_result($myclave,0,0); //nombre del usuario logueado.
               //Direccionamos a nuestra página principal del sistema.
               header ("Location: ../app.html");
          }
          else{
              echo"<script>alert('La contrase\u00f1a del usuario no es correcta.');
              window.location.href=\"index.html\"</script>"; 
          }
     }else{
	 echo "Lo sentimos, no se ha podido conectar con la base datos: $nmyusuario<br>";
          echo"<script>alert('El usuario no existe.');window.location.href=\"index.html\"</script>";
     }
     mysql_close($idconnect);
?>
