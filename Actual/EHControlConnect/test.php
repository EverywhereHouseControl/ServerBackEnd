<!doctype html>
<html>
	<head>
		<title>Test API server</title>
	</head>
<body>
  <form action="http://ehcontrol.net/EHControlConnect/index.php" method="POST">

  Command: <input type="text" name="command" /></br>
  username: <input type="text" name="username" /></br>
  password: <input type="text" name="password" /></br>
  email: <input type="text" name="email" /></br>
  hint: <input type="text" name="hint" /></br>
  n_username: <input type="text" name="n_username" /></br>
  n_password: <input type="text" name="n_password" /></br>
  n_email: <input type="text" name="n_email" /></br>
  n_hint: <input type="text" name="n_hint" /></br>
  housename: <input type="text" name="housename" /></br>
  roomname: <input type="text" name="roomname" /></br>
  servicename: <input type="text" name="servicename" /></br>
  actionname: <input type="text" name="actionname" /></br>
  n_housename: <input type="text" name="n_housename" /></br>
  n_roomname: <input type="text" name="n_roomname" /></br>
  data: <input type="text" name="data" /></br>
  start: <input type="text" name="start" /></br>
  idaction: <input type="text" name="idaction" /></br>
  taskname: <input type="text" name="taskname" /></br>
  commandname: <input type="text" name="commandname" /></br>
  description: <input type="text" name="description" /></br>
  frequency: <input type="text" name="frequency" /></br>
  idtask: <input type="text" name="idtask" /></br>
  devicename: <input type="text" name="devicename" /></br>
  ipaddress: <input type="text" name="ipaddress" /></br>
  city: <input type="text" name="city" /></br>
  country: <input type="text" name="country" /></br>
  language: <input type="text" name="language" /></br>
  number: <input type="text" name="number" /></br>
  serial: <input type="text" name="serial" /></br>
  idimage: <input type="text" name="idimage" /></br>

  <input type="submit" />
  </form>
  	
	<body>
		<form action="http://ehcontrol.net/EHControlConnect/index.php" method="POST" enctype="multipart/form-data">
		    <label for="imagen">Imagen:</label>
		    <input type="file" name="imagen" id="imagen" />
		    <input type="submit" name="subir" value="Subir"/>
		    <input type="text" name="command" value="subir"/>
		</form>
</body>
</html>
