<?php
	$con = new mysqli('localhost','root','123Pass123','ess_recruiting');
	if(!$con){
	die('could not connect: ' . mysqli_error($con));
	}

	$filter = "";
	if($_GET['Region'] && $_GET['Region'] != "All")
		$filter = " AND schools.region='" . $_GET['Region'] . "'"; 

	$query = "SELECT 	prospects.name AS Name,
										prospects.position AS Pos,
										attributes.level AS Level, 
										schools.name AS School, 
										ifnull(nullif(prospects.jersey_no, ''), 'N/A') AS Number,
										attributes.height AS Height,
										attributes.weight AS Weight,
										prospects.year AS Year									
   					FROM prospects, attributes, schools, contact_info 
						WHERE prospects.prospect_id = attributes.prospect_id
						AND prospects.prospect_id = contact_info.prospect_id
						AND prospects.school_id = schools.school_id$filter GROUP BY schools.name";
	$result = mysqli_query($con, $query) or die (mysqli_error($con));
	
	while($r = mysqli_fetch_assoc($result)) {
		$rows[] = $r;
	}	
	
	echo json_encode($rows);

	mysqli_close($con);
?>
