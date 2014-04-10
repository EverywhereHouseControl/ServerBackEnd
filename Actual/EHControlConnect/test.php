<?php
  if( $_POST["name"] || $_POST["age"] )
  {
     echo "Welcome ". $_POST['name']. "<br />";
     echo "You are ". $_POST['age']. " years old.";
     exit();
  }
?>
<html>
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
  data: <input type="text" name="data" /></br>
  start: <input type="text" name="start" /></br>
  idaction: <input type="text" name="idaction" /></br>
  taskname: <input type="text" name="taskname" /></br>
  description: <input type="text" name="description" /></br>
  frequency: <input type="text" name="frequency" /></br>
  idtask: <input type="text" name="idtask" /></br>
  device: <input type="text" name="device" /></br>
  ciudad: <input type="text" name="city" /></br>
  pais: <input type="text" name="country" /></br>
  idioma: <input type="text" name="language" /></br>

  <input type="submit" />
  </form>
</body>
</html>
