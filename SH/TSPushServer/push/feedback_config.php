<?php

// Configuration file for feedback.php

$config = array(
	// These are the settings for development mode
	'development' => array(

		// The APNS feedback server that we will use
		'server' => 'feedback.sandbox.push.apple.com:2196',

		// The SSL certificate that allows us to connect to the APNS servers
		'certificate' => '/dev/ck.pem',
		'passphrase' => 'certtrivik7',

		// Configuration of the MySQL database
		'db' => array(
			'host'     => 'localhost',
			'dbname'   => 'triviseries_push_dev',
			'username' => 'User_Trivi_Push',
			'password' => '1c28729j7$push',
			),
		),

	// These are the settings for production mode
	'production' => array(

		// The APNS feedback server that we will use
		'server' => 'feedback.push.apple.com:2196',

		// The SSL certificate that allows us to connect to the APNS servers
		'certificate' => '/prod/ck.pem',
		'passphrase' => 'C02HQ3DSDTY3',

		// Configuration of the MySQL database
		'db' => array(
			'host'     => 'localhost',
			'dbname'   => 'triviseries_push_prod',
			'username' => 'UserTriviPush',
			'password' => '1c28729j7$push',
			),
		),
	);
