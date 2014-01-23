<?php

try{
	$postdata = array(
				'command' => "dameFila"
			);

	$result = do_post_request("http://ehcontrol.net/iReporter/index.php", $postdata);
	
	echo $result;
	
}
catch (Exception $e){
	
}

function do_post_request($url, $postdata){
  $content = "";

  // Add post data to request.
  foreach($postdata as $key => $value)
  {
    $content .= "{$key}={$value}&";
  }

  $params = array('http' => array(
    'method' => 'POST',
    'header' => 'Content-Type: application/x-www-form-urlencoded',
    'content' => $content
  ));

  $ctx = stream_context_create($params);
  $fp = fopen($url, 'rb', false, $ctx);

  if (!$fp) {
    throw new Exception("Connection problem, {$php_errormsg}");
  }

  $response = @stream_get_contents($fp);
  if ($response === false) {
    throw new Exception("Response error, {$php_errormsg}");
  }

  return $response;
}

?>

