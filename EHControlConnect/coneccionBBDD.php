<?php


//the file coneccion.php used for the connection to the server
require_once("/var/www/EHControlConnect/coneccion.php");


//a query to the database table is CRONACTIONS
$sql = "SELECT * FROM CRONACTIONS limit 0,100";
$result = mysql_query($sql,$link);
if($result ===FALSE){
       die(mysql_error());//shows errors in the log file
}
$output=array();
$id=array();
$outputClima=array();

//query data in the database and execution of scripts, in this case the script climate
while($out = mysql_fetch_array($result))
{	  
	$city=$out['city'];
	
	$country=$out['country'];
	
	$language=$out['language'];
	
	$idi=$out['id'];
	$id[]=$idi;
        //execution of the script considering the absolute directory where this script is
	exec(dirname(__FILE__).'/clima '.$city.','.$country.' '.$language,$outputClima);
	
	
	$output[$idi]=$outputClima;
	
}
//upgrade the data bas	 	
	$j=0;
	foreach($id as $i){
	$var=$output[$i];
	$sql = "UPDATE `ehcontrol`.`CRONACTIONS` SET `Salida`='$var[$j]' WHERE `CRONACTIONS`.`id` = $i";
	$j++;
	$result = mysql_query($sql,$link);
	
	//echo $result;
	}
?>
