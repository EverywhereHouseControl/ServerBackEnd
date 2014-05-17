<?php



require_once("/var/www/EHControlConnect/coneccion.php");//EHControlConnect/
//require_once("/var/www/EHControlConnect/api.php");


$sql = "SELECT DISTINCT CITY,COUNTRY FROM HOUSES";
$result = mysql_query($sql,$link);
if($result ===FALSE){
       die(mysql_error());
}
$output=array();
$id=array();
$outputClima=array();
$country=array();
$city=array();


while($out = mysql_fetch_array($result))
{	  
	$city[]=$out['CITY'];
	if(isset($out['COUNTRY']))
	 $country[]=$out['COUNTRY'];
	else {$country[]="";}
	$language="en";
	
	
	exec(dirname(__FILE__).'/clima '.$out['CITY'].','.$out['COUNTRY'].' '.$language,$outputClima);
	//exec(dirname(__FILE__).'/clima '.$city.','.$country.' '. $language,$outputClima);
	
	$output[]=$outputClima;
	
}
	 	
   $i=0;
   foreach($output as $outClima){
   if(isset($country[$i]))
	  $country[$i]=trim($country[$i],',');
	if(isset($city[$i]))
	  $city[$i]=trim($city[$i],',');
	$sql = "delete  from CRONACTIONS where city='$city[$i]' AND country='$country[$i]'";
	$result = mysql_query($sql,$link);
	$i++;
    }
	$i=0;
	foreach($output as $outClima){
	if(isset($country[$i]))
	  $country[$i]=trim($country[$i],',');
	if(isset($city[$i]))
	  $city[$i]=trim($city[$i],',');

	$sql="insert into CRONACTIONS (city,country,language,Salida,id)values('$city[$i]','$country[$i]','en','$outputClima[$i]',null)";
	$result = mysql_query($sql,$link);
	$i++;
	}
	
?>
