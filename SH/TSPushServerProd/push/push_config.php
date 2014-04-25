<?php

// Configuration file for push.php

$config = array(
	// These are the settings for development mode
	'development' => array(

		// The APNS server that we will use
		'server' => 'ssl://gateway.sandbox.push.apple.com:2195',

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

		// Name and path of our log file
		'logfile' => '/home/kinki/Archer/TSPushServer/log/push_development.log',
		),

	// These are the settings for production mode
	'production' => array(

		// The APNS server that we will use
		'server' => 'ssl://gateway.push.apple.com:2195',

		// The SSL certificate that allows us to connect to the APNS servers
		'certificate' => 'ck.pem',
		'passphrase' => 'C02HQ3DSDTY3',

		// Configuration of the MySQL database
		'db' => array(
			'host'     => 'localhost',
			'dbname'   => 'triviseries_push_prod',
			'username' => 'UserTriviPush',
			'password' => '1c28729j7$push',
			),

		// Name and path of our log file
		'logfile' => '/home/kinki/Archer/TSPushServerProd/log/push_production.log',
		),
	);
