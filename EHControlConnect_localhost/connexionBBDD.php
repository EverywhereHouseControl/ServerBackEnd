<?php



require_once("/var/www/EHControlConnect/connexion.php");//EHControlConnect/
//require_once("/var/www/EHControlConnect/api.php");


$sql = "SELECT * FROM CRONACTIONS limit 0,100";
$result = mysql_query($sql,$link);
if($result ===FALSE){
       die(mysql_error());
}
$output=array();
$id=array();
$outputClima=array();

while($out = mysql_fetch_array($result))
{	  
	$city=$out['city'];
	
	$country=$out['country'];
	
	$language=$out['language'];
	
	$idi=$out['id'];
	$id[]=$idi;
	exec(dirname(__FILE__).'/clima '.$city.','.$country.' '.$language,$outputClima);
	//exec(dirname(__FILE__).'/clima '.$city.','.$country.' '. $language,$outputClima);
	
	$output[$idi]=$outputClima;
	
}
	 	
	$j=0;
	foreach($id as $i){
	$var=$output[$i];
	$sql = "UPDATE `ehcontrol`.`CRONACTIONS` SET `Salida`='$var[$j]' WHERE `CRONACTIONS`.`id` = $i";
	$j++;
	$result = mysql_query($sql,$link);
	
	//echo $result;
	}
?>
