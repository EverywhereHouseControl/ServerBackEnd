<?php

// API access key from Google API's Console
//$api = $_GET['api'];
define( 'API_ACCESS_KEY', 'AIzaSyA6_HOqzLfxsDTRCI9eSHsiCY24ggVmzP0' );

$registrationIds = array($_GET['regID']);

$message = $_GET['msg'];

// prep the bundle
$msg = array('mensaje' => "$message");

$fields = array
(
	'registration_ids' 	=> $registrationIds,
	'data'				=> $msg
);
 
$headers = array
(
	'Authorization: key=' . API_ACCESS_KEY,
	'Content-Type: application/json'
);
 
$ch = curl_init();
curl_setopt( $ch,CURLOPT_URL, 'https://android.googleapis.com/gcm/send' );
curl_setopt( $ch,CURLOPT_POST, true );
curl_setopt( $ch,CURLOPT_HTTPHEADER, $headers );
curl_setopt( $ch,CURLOPT_RETURNTRANSFER, true );
curl_setopt( $ch,CURLOPT_SSL_VERIFYPEER, false );
curl_setopt( $ch,CURLOPT_POSTFIELDS, json_encode( $fields ) );
$result = curl_exec($ch );
curl_close( $ch );
//echo "ENVIADO!!";

echo $result;


?>
