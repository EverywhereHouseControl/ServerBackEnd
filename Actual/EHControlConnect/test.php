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
  housename: <input type="text" name="housename" /></br>
  roomname: <input type="text" name="roomname" /></br>
  servicename: <input type="text" name="servicename" /></br>
  actionname: <input type="text" name="actionname" /></br>
  data: <input type="text" name="data" /></br>
  device: <input type="text" name="device" /></br>
  ciudad: <input type="text" name="city" /></br>
  pais: <input type="text" name="country" /></br>
  idioma: <input type="text" name="idioma" /></br>

  <input type="submit" />
  </form>
</body>
</html>
