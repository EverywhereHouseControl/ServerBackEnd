<?php
$username = "server";
$password = "revres";
if ($_POST['txtUsername'] != $username || $_POST['txtPassword'] != $password) {
?>
	<head>
		<title>Test API server</title>
	</head>
	<div style="position: absolute; left: 309px; top: 18px; width: 294px; height: 173px;">
			<h2>
				<span style="font-family:arial,helvetica,sans-serif;"><span style="color: rgb(0, 0, 205);">Test API, restricted area</span></span></h2>
			<form action="" method="post" name="form">
				<p>
					<label for="txtUsername">Username:</label><br />
					<input name="txtUsername" title="Introduce nombre de usuario" type="text" /></p>
				<p>
					<label for="txtpassword">Password:</label></p>
				<p>
					<input name="txtPassword" title="Introduce la contraseña" type="password" /></p>
				<p>
					<input name="Submit" type="submit" value="Login" /></p>
			</form>
		</div>
		<div style="position: absolute; left: 87px; top: 57px; width: 100px; height: 100px;">
			<img alt="" src="http://ehcontrol.net/images/logo.png" style="width: 200px; height: 200px;" /></div>
<?php
}else {
?>
<p>Test now protected by password.</p>
<!doctype html>
<html>
	<head>
		<title>Test API server</title>
	</head>
	<body>
		<form action="http://ehcontrol.net/EHControlConnect/index.php" method="POST">
			<pre>
  command:     <select name="command" size="1">
  				<option selected="selected" value="login2">login2</option>
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
  				<option value="schedulehouse">schedulehouse</option>
  				<option value="createroom">createroom</option>
  				<option value="deleteroom">deleteroom</option>
  				<option value="modifyroom">modifyroom</option>
  				<option value="createaccesshouse">createaccesshouse</option>
  				<option value="deleteaccesshouse">deleteaccesshouse</option>
  				<option value="image">image</option>
  				<option value="createdevice">createdevice</option>
  				<option value="deletedevice">deletedevice</option>
  				<option value="modifyservicetype">modifyservicetype</option>
  				<option value="createpermissionservice">createpermissionservice</option>
  				<option value="deletepermissionservice">deletepermissionservice</option>
  				<option value="linkserviceroom">linkserviceroom</option>
  				<option value="unlinkserviceroom">unlinkserviceroom</option> 
  				</select>                          <input type="submit" value="Execute" />
  username:    <input name="username" size="50" type="text" />
  password:    <input name="password" size="50" type="text" />
  email:       <input name="email" size="50" type="text" />
  hint:        <input name="hint" size="50" type="text" />
  n_username:  <input name="n_username" size="50" type="text" />
  n_password:  <input name="n_password" size="50" type="text" />
  n_email:     <input name="n_email" size="50" type="text" />
  n_hint:      <input name="n_hint" size="50" type="text" />
  housename:   <input name="housename" size="50" type="text" />
  roomname:    <input name="roomname" size="50" type="text" />
  servicename: <input name="servicename" size="50" type="text" />
  actionname:  <input name="actionname" size="50" type="text" />
  n_housename: <input name="n_housename" size="50" type="text" />
  n_roomname:  <input name="n_roomname" size="50" type="text" />
  data:        <input name="data" size="50" type="text" />
  start:       <input name="start" size="50" type="text" />
  idaction:    <input name="idaction" size="50" type="text" />
  iddevice:    <input name="iddevice" size="50" type="text" />
  idservice:   <input name="idservice" size="50" type="text" />
  idroom:      <input name="idroom" size="50" type="text" />
  taskname:    <input name="taskname" size="50" type="text" />
  idtask:      <input name="idtask" size="50" type="text" />
  commandname: <input name="commandname" size="50" type="text" />
  description: <input name="description" size="50" type="text" />
  frequency:   <input name="frequency" size="50" type="text" />
  type:        <input name="type" size="50" type="text" />
  devicename:  <input name="devicename" size="50" type="text" />
  ipaddress:   <input name="ipaddress" size="50" type="text" />
  city:        <input name="city" size="50" type="text" />
  country:     <input name="country" size="50" type="text" />
  language:    <input name="language" size="50" type="text" />
  number:      <input name="number" size="50" type="text" />
  serial:      <input name="serial" size="50" type="text" />
  idimage:     <input name="idimage" size="50" type="text" />
</pre>
		</form>
		<form action="http://ehcontrol.net/EHControlConnect/index.php" enctype="multipart/form-data" method="POST">
			<label for="imagen">Imagen:</label> <input id="imagen" name="imagen" type="file" /> <input name="subir" type="submit" value="Subir" /> <input name="command" type="text" value="subir" />&nbsp;</form>
		<div style="position: absolute; left: 526px; top: 93px; width: 100px; height: 100px;">
			<img alt="" src="http://ehcontrol.net/images/logo.png" style="width: 200px; height: 200px;" /></div>
		<div style="position: absolute; left: 479px; top: 282px; width: 310px; height: 100px;">
			<span style="font-size:18px;"><span style="font-family: arial,helvetica,sans-serif;"><span style="color: rgb(0, 0, 205);">API SERVER TESTING INTERFACE</span></span></span></div>
	</body>

</html>
<?php
}
?> 
