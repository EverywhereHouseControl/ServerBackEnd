<?php


require("lib.php");
require("api.php");



$username = "phpconect";
$password = "tcenocphp";
$hostname = "localhost"; 

//connection to the database
$dbhandle = mysql_connect($hostname, $username, $password) 
 or die("Unable to connect to MySQL");


//select a database to work with
$selected = mysql_select_db("ehcontrol",$dbhandle) 
  or die("Could not select examples");

//select Date Now

$dateNow = date("Y-m-d H:i:s");
//execute the SQL query and return records
$result = query("SELECT * FROM PROGRAMACTIONS WHERE STARTTIME < CURRENT_TIMESTAMP;",$dateNow);
//echo "<br>";
//fetch tha data from the database 
$n = count($result['result']);
$idprog=array();
$prognam=array();
$iduser=array();
$idaction=array();
$data=array();

for ($i = 0; $i<$n; $i++) {
  $idprogaux=$result['result'][$i]['IDPROGRAM'];
  if(isset($idprogaux)){
	$idprog[]=$idprogaux;}
  else{$idprog[]="";} 

  $idprogaux=$result['result'][$i]['PROGRAMNAME'];  
  if(isset($idprogaux)){
	$prognam[]=$idprogaux;}
  else{$prognam[]="";} 

  $idprogaux=$result['result'][$i]['IDUSER'];
  if(isset($idprogaux)){
	$iduser[]=$idprogaux;}
  else{$iduser[]="";} 

$idprogaux=$result['result'][$i]['IDACTION'];
  if(isset($idprogaux)){
	$idaction[]=$idprogaux;}
  else{$idaction[]="";} 

$idprogaux=$result['result'][$i]['DATA'];
  if(isset($idprogaux)){
	$data[]=$idprogaux;}
  else{$data[]="";} 


$idprogaux=$result['result'][$i]['IDPROGRAM'];
  if(isset($idprogaux)){
	$idprogram[]=$idprogaux;}
  else{$idprogram[]="";} 

//echo $result['result'][$i]['STARTTIME']."\n";
//echo $result['result'][$i]['DATEBEGIN']."\n";

}
$j=0;
foreach($iduser as $idu){
$username=array();
$housename=array();
$roomname=array();
$idroom=array();
$actionname=array();
$idservice=array();
$fileDatos=array();
$servicename=array();

$sql="SELECT DISTINCT USERNAME FROM USERS WHERE IDUSER='$idu'";
$result = mysql_query($sql,$dbhandle);
if($result ===FALSE){
       die(mysql_error());
}

while($out = mysql_fetch_array($result)){	  
	$userito=$out['USERNAME'];	
	if(isset($userito))	
	{$username[]=$userito;}
	else{
		$username[]="";
	}
}

$fileDatos['username']=$username;

$sql="SELECT DISTINCT HOUSENAME FROM HOUSES WHERE IDUSER='$idu'";
$result = mysql_query($sql,$dbhandle);
if($result ===FALSE){
       die(mysql_error());
}

while($out = mysql_fetch_array($result)){	  
	$houseito=$out['HOUSENAME'];	
	if(isset($houseito)){	
	$housename[]=$houseito;}
	else{
	$housename[]="";
	}
}

$fileDatos['housename']=$housename;

$sql="SELECT DISTINCT ACTIONNAME,IDSERVICE FROM ACTIONS WHERE IDACTION='$idaction[$j]'";
$result = mysql_query($sql,$dbhandle);
if($result ===FALSE){
       die(mysql_error());
}

while($out = mysql_fetch_array($result)){	  
	$actionito=$out['ACTIONNAME'];	
	if(isset($actionito)){	
	$actionname[]=$actionito;}
	else{
	$actionname[]="";}

	$actionito=$out['IDSERVICE'];	
	if(isset($actionito)){	
	$idservice[]=$actionito;}
	else{
	$idservice[]="";
	}
}

$fileDatos['actionname']=$actionname;
$fileDatos['idservice']=$idservice;

foreach($idservice as $ids){

$sql="SELECT DISTINCT IDROOM,SERVICENAME FROM SERVICES WHERE IDSERVICE='$ids'";
$result = mysql_query($sql,$dbhandle);
if($result ===FALSE){
       die(mysql_error());
}

while($out = mysql_fetch_array($result)){	  
	$idroomito=$out['IDROOM'];	
	if(isset($idroomito)){	
	$idroom[]=$idroomito;}
	else{
	$idroom[]="";
	}
	
	$servito=$out['SERVICENAME'];	
	if(isset($servito)){	
	$servicename[]=$servito;}
	else{
	$servicename[]="";
	}
}
}
$fileDatos['servicename']=$servicename;

foreach($idroom as $idr){

$sql="SELECT DISTINCT ROOMNAME FROM ROOMS WHERE IDROOM='$idr'";
$result = mysql_query($sql,$dbhandle);
if($result ===FALSE){
       die(mysql_error());
}

while($out = mysql_fetch_array($result)){	  
	$roomito=$out['ROOMNAME'];	
	if(isset($roomito)){	
	$roomname[]=$roomito;}
	else{
	$roomname[]="";
	}
	
}
}

$fileDatos['roomname']=$roomname;
$fileDatos['housename']='fdi DEMO3';

///var_dump($fileDatos);


$aux = "Facultad de Informatica UCM";


doactionevent($fileDatos['username'][0],$fileDatos['housename'],$fileDatos['roomname'][0],$fileDatos['servicename'][0],$fileDatos['actionname'][0],$data[$j]);

//var_dump($fileDatos);


$sql="DELETE from PROGRAMACTIONS WHERE IDPROGRAM='$idprogram[$j]'";
$result = mysql_query($sql,$dbhandle);

$j++;
}


//close the connection
mysql_close($dbhandle);

?>
