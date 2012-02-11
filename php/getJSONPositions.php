<?php
// New Connection
	$db = new mysqli('localhost','root','123Pass123','ess_recruiting');

// Check for errors
	if(mysqli_connect_errno()){
 		echo mysqli_connect_error();
	}

// 1st Query
	$result = $db->query("SELECT position FROM prospects GROUP BY position ORDER BY position");
	if($result){
// Cycle through results
    	while($r = mysqli_fetch_row($result)){
			$rows[] = $r[0];
	}
	echo json_encode($rows);
// Free result set
    	$result->close();
    	$db->next_result();
	}
	$db->close();
?>
