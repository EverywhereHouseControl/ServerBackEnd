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
  Username: <input type="text" name="username" /></br>
  Password: <input type="text" name="password" /></br>
  n_username: <input type="text" name="n_username" /></br>
  n_password: <input type="text" name="n_password" /></br>
  n_email: <input type="text" name="n_email" /></br>
  n_hint: <input type="text" name="n_hint" /></br>
  house_name: <input type="text" name="house_name" /></br>
  room_name: <input type="text" name="room_name" /></br>
  service_name: <input type="text" name="service_name" /></br>
  action_name: <input type="text" name="action_name" /></br>
  data: <input type="text" name="data" /></br>
  device: <input type="text" name="device" /></br>
  ciudad: <input type="text" name="ciudad" /></br>
  pais: <input type="text" name="pais" /></br>
  idioma: <input type="text" name="idioma" /></br>

  <input type="submit" />
  </form>
</body>
</html>