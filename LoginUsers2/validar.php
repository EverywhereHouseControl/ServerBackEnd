<!DOCTYPE html>
<html lang="es">
<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Everywhere House Control</title>
<link rel="stylesheet" href="css/estiloLogin.css" type="text/css" media="all">
</head>
<body>
<?php
if (isset($_POST['nombre']) && isset($_POST['clave']))
    {
    if (($_POST['nombre']=="jose")&&($_POST['clave']=="jose") )
        {
        session_start();
        $_SESSION['usuario']="usuario";
        $_SESSION['tiempo']=time();
        header("location:flat/index.html");
        }
    else
        header("location:index.php");
 
    }
else
    {
    ?>
    <div id="wrapper">

	<form name="login-form" class="login-form" action="validar.php" method="POST">
	
		<div class="header">
		<h1>EHC Login</h1>
		<span>Entra en la App Web de EHC.</span>
		</div>
	
		<div class="content">
			<input name="nombre" type="text" class="input username" placeholder="Username" />
			<div class="user-icon"></div>
				<input name="clave" type="password" class="input password" placeholder="Password" />
			<div class="pass-icon"></div>		
		</div>

		<div class="footer">
		<input type="submit" name="submit" value="Acceder" class="button" />
		<input type="submit" name="submit" value="Register" class="register" />
		</div>
	
	</form>

</div>
<div class="gradient"></div>
    
    <?php
    }
?>
</body>
</html>