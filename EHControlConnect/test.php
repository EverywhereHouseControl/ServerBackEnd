<?php

//relative server address
$host  = $_SERVER['HTTP_HOST'];
$uri   = rtrim(dirname($_SERVER['PHP_SELF']), '/\\');

//autentication information
$username = "server";
$password = "revres";

//autentication check
if ($_POST['txtUsername'] != $username || $_POST['txtPassword'] != $password) {
?>
<head>
<title>Test API server</title>
</head>
<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/"><img alt="Licencia de Creative Commons" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" /></a><br />
<p>&nbsp;</p>
<p>&nbsp;</p>
<div style="margin-left: -300px;" align="center">
	<img style="width: 200px; height: 200px;"
		src="images/logo.png" alt="" />
	<div
		style="position: relative; left: 300px; top: -220px; width: 294px; height: 173px;">
		<h2 style="text-align: left;">
			<span style="font-family: arial, helvetica, sans-serif;"><span
				style="color: #0000cd;">Test API, restricted area</span></span>
		</h2>
		<form action="" method="post" name="form">
			<p style="text-align: left;">
				<label for="txtUsername">Username:</label><br /> <input
					title="Introduce nombre de usuario" type="text" name="txtUsername" />
			</p>
			<p style="text-align: left;">
				<label for="txtpassword">Password:</label>
			</p>
			<p style="text-align: left;">
				<input title="Introduce la contrase&ntilde;a" type="password"
					name="txtPassword" />
			</p>
			<p style="text-align: left;">
				<input type="submit" name="Submit" value="Login" />
			</p>
		</form>
	</div>
	
</div>
<?php
}else {
?>
<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/"><img alt="Licencia de Creative Commons" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" /></a><br />
<!doctype html>
<html>
<head>
<title>Test API server</title>
</head>
<body>
<script>
        function show(){
            var option = document.getElementById("command").value;
            switch (option){
            case "login3":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="block";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="block";
            	document.getElementById("os").style.display="block";
	        	break;
            case "logout":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="block";
            	document.getElementById("os").style.display="none";
	        	break;
            case "login2":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="block";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "createuser2":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="block";
            	document.getElementById("email").style.display="block";
            	document.getElementById("hint").style.display="block";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "deleteuser2":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="block";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "modifyuser2":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="block";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="block";
            	document.getElementById("n_password").style.display="block";
            	document.getElementById("n_email").style.display="block";
            	document.getElementById("n_hint").style.display="block";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="block";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "doaction":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="block";
            	document.getElementById("roomname").style.display="block";
            	document.getElementById("servicename").style.display="block";
            	document.getElementById("actionname").style.display="block";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="block";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "ipcheck":
            	document.getElementById("username").style.display="none";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="block";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "getweather":
            	document.getElementById("username").style.display="none";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="block";
            	document.getElementById("country").style.display="block";
            	document.getElementById("language").style.display="block";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "lostpass":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "createhouse":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="block";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="block";
            	document.getElementById("country").style.display="block";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "deletehouse":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="block";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="block";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "modifyhouse":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="block";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="block";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="block";
            	document.getElementById("country").style.display="block";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="block";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "createprogramaction":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="block";
            	document.getElementById("roomname").style.display="block";
            	document.getElementById("servicename").style.display="block";
            	document.getElementById("actionname").style.display="block";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="block";
            	document.getElementById("start").style.display="block";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="block";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "deleteprogramaction":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="block";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "createtask":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="block";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="block";
            	document.getElementById("frequency").style.display="block";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "deletetask":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="block";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "addtaskprogram":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="block";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="block";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "removetaskprogram":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="block";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="block";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "addcommandprogram":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="block";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="block";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="block";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "removecommandprogram":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="block";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="block";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="block";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "createcommand":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="block";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "deletecommand":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="block";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "":
            	document.getElementById("username").style.display="none";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "createroom":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="block";
            	document.getElementById("roomname").style.display="block";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "deleteroom":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="block";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="block";
            	document.getElementById("roomname").style.display="block";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "createaccesshouse":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="block";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="block";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="block";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "deleteaccesshouse":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="block";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="block";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "createdevice":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="block";
            	document.getElementById("ipaddress").style.display="block";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="block";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "deletedevice":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="block";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="block";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "modifyservicetype":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="block";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="block";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="block";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "createpermissionservice":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="block";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="block";
            	document.getElementById("roomname").style.display="block";
            	document.getElementById("servicename").style.display="block";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="block";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "deletepermissionservice":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="block";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="block";
            	document.getElementById("roomname").style.display="block";
            	document.getElementById("servicename").style.display="block";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "linkserviceroom":
            	document.getElementById("username").style.display="none";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="block";
            	document.getElementById("idroom").style.display="block";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "unlinkserviceroom":
            	document.getElementById("username").style.display="none";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="block";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            case "subir":
            	document.getElementById("username").style.display="none";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="none";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="none";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="block";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
			case "UPDATE":
            	document.getElementById("username").style.display="none";
            	document.getElementById("password").style.display="none";
            	document.getElementById("email").style.display="none";
            	document.getElementById("hint").style.display="none";
            	document.getElementById("n_username").style.display="none";
            	document.getElementById("n_password").style.display="none";
            	document.getElementById("n_email").style.display="none";
            	document.getElementById("n_hint").style.display="none";
            	document.getElementById("housename").style.display="none";
            	document.getElementById("roomname").style.display="none";
            	document.getElementById("servicename").style.display="none";
            	document.getElementById("actionname").style.display="none";
            	document.getElementById("n_housename").style.display="none";
            	document.getElementById("n_roomname").style.display="none";
            	document.getElementById("data").style.display="block";
            	document.getElementById("start").style.display="none";
            	document.getElementById("idaction").style.display="none";
            	document.getElementById("iddevice").style.display="none";
            	document.getElementById("idservice").style.display="block";
            	document.getElementById("idroom").style.display="none";
            	document.getElementById("taskname").style.display="none";
            	document.getElementById("idtask").style.display="none";
            	document.getElementById("commandname").style.display="none";
            	document.getElementById("description").style.display="none";
            	document.getElementById("frequency").style.display="none";
            	document.getElementById("type").style.display="none";
            	document.getElementById("devicename").style.display="none";
            	document.getElementById("ipaddress").style.display="none";
            	document.getElementById("city").style.display="none";
            	document.getElementById("country").style.display="none";
            	document.getElementById("language").style.display="none";
            	document.getElementById("number").style.display="none";
            	document.getElementById("serial").style.display="none";
            	document.getElementById("image").style.display="none";
            	document.getElementById("loadfile").style.display="none";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;
            	/*   case "login2":
            	document.getElementById("username").style.display="block";
            	document.getElementById("password").style.display="block";
            	document.getElementById("email").style.display="block";
            	document.getElementById("hint").style.display="block";
            	document.getElementById("n_username").style.display="block";
            	document.getElementById("n_password").style.display="block";
            	document.getElementById("n_email").style.display="block";
            	document.getElementById("n_hint").style.display="block";
            	document.getElementById("housename").style.display="block";
            	document.getElementById("roomname").style.display="block";
            	document.getElementById("servicename").style.display="block";
            	document.getElementById("actionname").style.display="block";
            	document.getElementById("n_housename").style.display="block";
            	document.getElementById("n_roomname").style.display="block";
            	document.getElementById("data").style.display="block";
            	document.getElementById("start").style.display="block";
            	document.getElementById("idaction").style.display="block";
            	document.getElementById("iddevice").style.display="block";
            	document.getElementById("idservice").style.display="block";
            	document.getElementById("idroom").style.display="block";
            	document.getElementById("taskname").style.display="block";
            	document.getElementById("idtask").style.display="block";
            	document.getElementById("commandname").style.display="block";
            	document.getElementById("description").style.display="block";
            	document.getElementById("frequency").style.display="block";
            	document.getElementById("type").style.display="block";
            	document.getElementById("devicename").style.display="block";
            	document.getElementById("ipaddress").style.display="block";
            	document.getElementById("city").style.display="block";
            	document.getElementById("country").style.display="block";
            	document.getElementById("language").style.display="block";
            	document.getElementById("number").style.display="block";
            	document.getElementById("serial").style.display="block";
            	document.getElementById("image").style.display="block";
            	document.getElementById("loadfile").style.display="block";
            	document.getElementById("programname").style.display="none";
            	document.getElementById("regid").style.display="none";
            	document.getElementById("os").style.display="none";
            	break;*/
            }
        }
    </script>
    			<table>
				<tbody>
	<form action="index.php"
		method="POST">
		<pre>
<tr><td><pre>  command:     <select name="command" id="command" size="1" onclick="show()">
  				<option selected="selected" value=""></option>
  				<option value="login3">login3</option>
  				<option value="logout">logout</option>
  				<option value="login2">login2</option>
  				<option value="createuser2">createuser2</option>
  				<option value="deleteuser2">deleteuser2</option>
  				<option value="modifyuser2">modifyuser2</option>
  				<option value="doaction">doaction</option>
  				<option value="ipcheck">ipcheck</option>
  				<option value="getweather">getweather</option>
  				<option value="lostpass">lostpass</option>
  				<option value="createhouse">createhouse</option>
  				<option value="deletehouse">deletehouse</option>
  				<option value="modifyhouse">modifyhouse</option>
  				<option value="createprogramaction">createprogramaction</option>
  				<option value="deleteprogramaction">deleteprogramaction</option>
  				<option value="createtask">createtask</option>
  				<option value="deletetask">deletetask</option>
  				<option value="addtaskprogram">addtaskprogram</option>
  				<option value="removetaskprogram">removetaskprogram</option>
  				<option value="addcommandprogram">addcommandprogram</option>
  				<option value="removecommandprogram">removecommandprogram</option>
  				<option value="createcommand">createcommand</option>
  				<option value="deletecommand">deletecommand</option>
  				<!---<option value="schedulehouse">schedulehouse</option>--->
  				<option value="createroom">createroom</option>
  				<option value="deleteroom">deleteroom</option>
  				<!---<option value="modifyroom">modifyroom</option>-->
  				<option value="createaccesshouse">createaccesshouse</option>
  				<option value="deleteaccesshouse">deleteaccesshouse</option>
  				<!---<option value="image">image</option>--->
  				<option value="subir">subir</option>
  				<option value="createdevice">createdevice</option>
  				<option value="deletedevice">deletedevice</option>
  				<option value="modifyservicetype">modifyservicetype</option>
  				<option value="createpermissionservice">createpermissionservice</option>
  				<option value="deletepermissionservice">deletepermissionservice</option>
  				<option value="linkserviceroom">linkserviceroom</option>
  				<option value="unlinkserviceroom">unlinkserviceroom</option> 
  				<option value="UPDATE">UPDATE</option> 
  				</select>                          <input type="submit"
				value="Execute" /></pre></td></tr>
<tr id="username" style="display:none;"><td><pre>  username:    <input name="username" size="50" type="text" /></pre></td></tr>
<tr id="password" style="display:none;"><td><pre>  password:    <input name="password" size="50" type="text" </pre></td></tr>
<tr id="email" style="display:none;"><td><pre>  email:       <input name="email" size="50" type="text" </pre></td></tr>
<tr id="hint" style="display:none;"><td><pre>  hint:        <input name="hint" size="50" type="text" </pre></td></tr>
<tr id="n_username" style="display:none;"><td><pre>  n_username:  <input name="n_username" size="50" type="text" </pre></td></tr>
<tr id="n_password" style="display:none;"><td><pre>  n_password:  <input name="n_password" size="50" type="text" </pre></td></tr>
<tr id="n_email" style="display:none;"><td><pre>  n_email:     <input name="n_email" size="50" type="text" </pre></td></tr>
<tr id="n_hint" style="display:none;"><td><pre>  n_hint:      <input name="n_hint" size="50" type="text" </pre></td></tr>
<tr id="housename" style="display:none;"><td><pre>  housename:   <input name="housename" size="50" type="text" </pre></td></tr>
<tr id="roomname" style="display:none;"><td><pre>  roomname:    <input name="roomname" size="50" type="text" </pre></td></tr>
<tr id="servicename" style="display:none;"><td><pre>  servicename: <input name="servicename" size="50" type="text" </pre></td></tr>
<tr id="actionname" style="display:none;"><td><pre>  actionname:  <input name="actionname" size="50" type="text" </pre></td></tr>
<tr id="n_housename" style="display:none;"><td><pre>  n_housename: <input name="n_housename" size="50" type="text" </pre></td></tr>
<tr id="n_roomname" style="display:none;"><td><pre>  n_roomname:  <input name="n_roomname" size="50" type="text" </pre></td></tr>
<tr id="data" style="display:none;"><td><pre>  data:        <input name="data" size="50" type="text" </pre></td></tr>
<tr id="start" style="display:none;"><td><pre>  start:       <input name="start" size="50" type="text" </pre></td></tr>
<tr id="idaction" style="display:none;"><td><pre>  idaction:    <input name="idaction" size="50" type="text" </pre></td></tr>
<tr id="iddevice" style="display:none;"><td><pre>  iddevice:    <input name="iddevice" size="50" type="text" </pre></td></tr>
<tr id="idservice" style="display:none;"><td><pre>  idservice:   <input name="idservice" size="50" type="text" </pre></td></tr>
<tr id="idroom" style="display:none;"><td><pre>  idroom:      <input name="idroom" size="50" type="text" </pre></td></tr>
<tr id="taskname" style="display:none;"><td><pre>  taskname:    <input name="taskname" size="50" type="text" </pre></td></tr>
<tr id="idtask" style="display:none;"><td><pre>  idtask:      <input name="idtask" size="50" type="text" </pre></td></tr>
<tr id="commandname" style="display:none;"><td><pre>  commandname: <input name="commandname" size="50" type="text" </pre></td></tr>
<tr id="description" style="display:none;"><td><pre>  description: <input name="description" size="50" type="text" </pre></td></tr>
<tr id="frequency" style="display:none;"><td><pre>  frequency:   <input name="frequency" size="50" type="text" </pre></td></tr>
<tr id="type" style="display:none;"><td><pre>  type:        <input name="type" size="50" type="text" </pre></td></tr>
<tr id="devicename" style="display:none;"><td><pre>  devicename:  <input name="devicename" size="50" type="text" </pre></td></tr>
<tr id="ipaddress" style="display:none;"><td><pre>  ipaddress:   <input name="ipaddress" size="50" type="text" </pre></td></tr>
<tr id="city" style="display:none;"><td><pre>  city:        <input name="city" size="50" type="text" </pre></td></tr>
<tr id="country" style="display:none;"><td><pre>  country:     <input name="country" size="50" type="text" </pre></td></tr>
<tr id="language" style="display:none;"><td><pre>  language:    <input name="language" size="50" type="text" </pre></td></tr>
<tr id="number" style="display:none;"><td><pre>  number:      <input name="number" size="50" type="text" </pre></td></tr>
<tr id="serial" style="display:none;"><td><pre>  serial:      <input name="serial" size="50" type="text" </pre></td></tr>
<tr id="image" style="display:none;"><td><pre>  image:       <input name="image" size="50" type="text" </pre></td></tr>
<tr id="programname" style="display:none;"><td><pre>  programname: <input name="programname" size="50" type="text" </pre></td></tr>
<tr id="regid" style="display:none;"><td><pre>  regid:       <input name="regid" size="50" type="text" </pre></td></tr>
<tr id="os" style="display:none;"><td><pre>  os:          <input name="os" size="50" type="text" </pre></td></tr>
</pre>
<tr id="loadfile" style="display:none;"><td>
	</form>
	<form action="index.php"
		enctype="multipart/form-data" method="POST">
		<label for="imagen">Imagen:</label> <input id="imagen" name="imagen"
			type="file" /> <input name="subir" type="submit" value="Subir" /> <input
			name="command" type="text" value="subir" />&nbsp;
	</form>
</td></tr>
<tr><td>
	<div
		style="position: absolute; left: 526px; top: 150px; width: 100; height: 100px;">
		<img alt="" src="images/logo.png"
			style="width: 200px; height: 200px;" />
	</div>
	<div
		style="position: absolute; left: 475px; top: 370px; width: 310px; height: 100px;">
		<span style="font-size: 18px;"><span
			style="font-family: arial, helvetica, sans-serif;"><span
				style="color: rgb(0, 0, 205);">API SERVER TESTING INTERFACE</span></span></span>
	</div>	
</td></tr>
</tbody>
</table>
</body>

</html>
<?php
}
?> 
