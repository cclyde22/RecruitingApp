<?php 
	$name = $_GET['name'];
	//open connection
	$con = new mysqli('localhost','root','123Pass123','ess_recruiting');
	if(!$con){
	die('could not connect: ' . mysqli_error($con));
	}

	//Get mother and father's names 
	$query = "SELECT name FROM family WHERE prospect_id = (SELECT prospect_id FROM prospects WHERE name = '$name') AND relationship = 'Mother'";

	$result = mysqli_query($con, $query) or die (mysqli_error($con));
	$r = mysqli_fetch_assoc($result);
	$mother = $r['name'];

	$query = "SELECT name FROM family WHERE prospect_id = (SELECT prospect_id FROM prospects WHERE name = '$name') AND relationship = 'Father'";

	$result = mysqli_query($con, $query) or die (mysqli_error($con));
	$r = mysqli_fetch_assoc($result);
	$father = $r['name'];

	//Get all other info
	$query = "SELECT	prospects.position AS Pos,
										ifnull(nullif(prospects.jersey_no, ''), 'N/A') AS Number,
										attributes.level AS Level, 
										schools.name AS School,
										schools.region AS Region, 
										attributes.height AS Height,
										attributes.weight AS Weight,
										prospects.year AS Year,
										ifnull(nullif(contact_info.cell,''), 'N/A') AS Cell,
										ifnull(nullif(contact_info.home_phone,''), 'N/A') AS Home,
										ifnull(nullif(contact_info.email,''), 'N/A') AS Email,
										ifnull(nullif(contact_info.address,''), 'N/A') AS Address									
   					FROM prospects, attributes, schools, contact_info, family 
						WHERE prospects.prospect_id = attributes.prospect_id
						AND prospects.prospect_id = contact_info.prospect_id
						AND prospects.school_id = schools.school_id
						AND prospects.name = '$name'";
	$result = mysqli_query($con, $query) or die (mysqli_error($con));
	
	if($r = mysqli_fetch_assoc($result)) {
?>
<html>
	<body>
	View/Edit Prospect
		<div id='info'></div>
		<form method = "post" action = "updateProspect.php">
			<div>
			<fieldset>
				<legend>Prospect Information</legend>
				Name:<input type = "text" name="name" size = "40" value = "<?php echo $name?>">
				Position:<input type = "text" name="position" size = "7" value = "<?php echo $r['Pos'];?>">
				Jersey Number:<input type = "text" name="jerseyNo" size = "3" value = "<?php echo $r['Number'];?>">
				Graduation Year:<input type = "text" name="gradYear" size = "4" value = "<?php echo $r['Year'];?>"><br>
				Height:<input type = "text" name="height" size = "6" value = "<?php echo $r['Height'];?>">
				Weight:<input type = "text" name="weight" size = "4" value = "<?php echo $r['Weight'];?>">
				Evaluation:<input type = "text" name="evaluation" size = "6" value = "<?php echo $r['Level'];?>">				
			</fieldset>
			</div>
			<div>
			<fieldset>
				<legend>Contact Information</legend>
				Cell:<input type="text" name="cellNo" size="10" value = "<?php echo $r['Cell'];?>">
				Home Phone:<input type="text" name="homeNo" size="10" value = "<?php echo $r['Home'];?>">
				Email:<input type="text" name="email" size="40" value = "<? echo $r['Email'];?>"><br>
				Address:<input type="text" name="address" size="100" value = "<?php echo $r['Address'];?>"><br>
				Mothers Name:<input type="text" name="momsName" size="40" value = "<?php if($mother == '') echo 'N/A'; else echo $mother;?>">
				Fathers Name:<input type="text" name="dadsName" size="40" value = "<?php if($father == '') echo 'N/A'; else echo $father;?>">
			</fieldset>
			</div>
			<div>
			<fieldset>
				<legend>School Information</legend>
				Name:<input type="text" name="schoolName" size="40" value = "<?php echo $r['School'];?>"><br>
				Region:<input type="text" name="region" size="40" value = "<?php echo $r['Region'];?>"><br>
			</fieldset>
			</div>
			<fieldset>
				Click here to <input type = submit value = "Edit"> the prospect 
			</fieldset>
			</div>
		</form>
<?php
	}
	else
		echo "Player not found";
	mysqli_close($con);
?>
	</body>
</html>
