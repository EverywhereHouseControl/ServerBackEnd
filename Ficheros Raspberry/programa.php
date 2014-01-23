<?php

include "php_serial.class.php";

function enviar($dato){
	//exec("python programa.py $dato ");
	$serial = new phpSerial;
	$serial->deviceSet("/dev/ttyACM0");
	$serial->deviceOpen();
	sleep(1);
	$serial->sendMessage($dato);
	$serial->deviceClose();
/* $fp = fopen("/dev/ttyACM2", "w+");
   while( !$fp){
	$n = n+1;
   	$fp = fopen("/dev/ttyACM"+$n, "w+");
	echo $n;
   }
   fwrite($fp,"H");
   fclose($fp);*/
}

enviar($argv[1]);

?>
