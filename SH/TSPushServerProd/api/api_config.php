<?php

// Configuration file for api.php

$config = array(
	// These are the settings for development mode
	'development' => array(
		'db' => array(
			'host'     => 'localhost',
			'dbname'   => 'triviseries_push_dev',
			'username' => 'User_Trivi_Push',
			'password' => '1c28729j7$push',
			),
		),

	// These are the settings for production mode
	'production' => array(
		'db' => array(
			'host'     => 'localhost',
			'dbname'   => 'triviseries_push_prod',
			'username' => 'UserTriviPush',
			'password' => '1c28729j7$push',
			),
		),
	);
