<?php
$code = $_GET ['code'];
?>
<html>
<head>
<title>Confirm register</title>
</head>
<body>
<?php
require ("lib.php");
$sqlregistration = query ( "SELECT * FROM REGISTRATIONS WHERE CODECONFIRM = '%s' limit 1;", $code );

if (count ( $sqlregistration ['result'] ) == 1) {
	query ( "DELETE FROM REGISTRATIONS WHERE CODECONFIRM = '%s' LIMIT 1;", $code );
	query ( "INSERT INTO `USERS` (`IDUSER`, `USERNAME`, `PASSWORD`, `EMAIL`, `HINT`, `DATEBEGIN`) VALUES
									(NULL, '%s', '%s', '%s', '%s', '%s');", 
										$sqlregistration ['result'][0]['USERNAME'],
										$sqlregistration ['result'][0]['PASSWORD'],
										$sqlregistration ['result'][0]['EMAIL'],
										$sqlregistration ['result'][0]['HINT'],
										$sqlregistration ['result'][0]['DATEBEGIN']);
	echo "You have successfully confirmed your account.";
} else {
	echo "The verification code is not valid.";
}
?>
</body>
</html>
