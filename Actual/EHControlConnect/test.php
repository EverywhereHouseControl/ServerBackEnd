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
				<option value="createhouse">createhouse</option>
				<option value="deletehouse">deletehouse</option>
				<option value="modifyhouse">modifyhouse</option>
				<option value="createprogramaction">createprogramaction</option>
				<option value="deleteprogramaction">deleteprogramaction</option>
				<option value="createtask">createtask</option>
				<option value="deletetask">deletetask</option>
				<option value="addtaskprogram">addtaskprogram</option>
				<option value="removetaskprogram">removetaskprogram</option>
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
			</select>                          <input type="submit" />
  username:    <input type="text" name="username" />
  password:    <input type="text" name="password" />
  email:       <input type="text" name="email" />
  hint:        <input type="text" name="hint" />
  n_username:  <input type="text" name="n_username" />
  n_password:  <input type="text" name="n_password" />
  n_email:     <input type="text" name="n_email" />
  n_hint:      <input type="text" name="n_hint" />
  housename:   <input type="text" name="housename" />
  roomname:    <input type="text" name="roomname" />
  servicename: <input type="text" name="servicename" />
  actionname:  <input type="text" name="actionname" />
  n_housename: <input type="text" name="n_housename" />
  n_roomname:  <input type="text" name="n_roomname" />
  data:        <input type="text" name="data" />
  start:       <input type="text" name="start" />
  idaction:    <input type="text" name="idaction" />
  taskname:    <input type="text" name="taskname" />
  commandname: <input type="text" name="commandname" />
  description: <input type="text" name="description" />
  frequency:   <input type="text" name="frequency" />
  idtask:      <input type="text" name="idtask" />
  devicename:  <input type="text" name="devicename" />
  ipaddress:   <input type="text" name="ipaddress" />
  city:        <input type="text" name="city" />
  country:     <input type="text" name="country" />
  language:    <input type="text" name="language" />
  number:      <input type="text" name="number" />
  serial:      <input type="text" name="serial" />
  idimage:     <input type="text" name="idimage" />
<span _fck_bookmark="1" style="display: none;"> </span></pre>
  </form>
  	
	<form action="http://ehcontrol.net/EHControlConnect/index.php" method="POST" enctype="multipart/form-data">
		<label for="imagen">Imagen:</label>
		<input type="file" name="imagen" id="imagen" />
		<input type="submit" name="subir" value="Subir"/>
		<input type="text" name="command" value="subir"/>
	</form>
</body>
</html>
