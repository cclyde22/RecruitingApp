<?php
// New Connection
	$con = new mysqli('localhost','root','123Pass123','ess_recruiting');

// Check for errors
	if(mysqli_connect_errno()){
 		echo mysqli_connect_error();
	}

// 1st Query
	$rows = array("All");
	$result = $con->query("SELECT region FROM schools GROUP BY region ORDER BY region");
// Cycle through results
	while($r = mysqli_fetch_row($result))
		$rows[] = $r[0];
	echo json_encode($rows);
	$con->close();
?>
