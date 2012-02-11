<html>
	<body>
	Add Prospect
		<div id='info'></div>
		<form method = "post" action = "insertProspect.php">
			<div>
			<fieldset>
				<legend>Prospect Information</legend>
				Name:<input type = "text" name="name" size = "40">
				Position:<input type = "text" name="position" size = "7">
				Jersey Number:<input type = "text" name="jerseyNo" size = "3">
				Graduation Year:<input type = "text" name="gradYear" size = "4"><br>
				Height:<input type = "text" name="height" size = "6">
				Weight:<input type = "text" name="weight" size = "4">
				Evaluation:<input type = "text" name="evaluation" size = "6">				
			</fieldset>
			</div>
			<div>
			<fieldset>
				<legend>Contact Information</legend>
				Cell:<input type="text" name="cellNo" size="10">
				Home Phone:<input type="text" name="homeNo" size="10">
				Email:<input type="text" name="email" size="40"><br>
				Address:<input type="text" name="address" size="100"><br>
				Mothers Name:<input type="text" name="momsName" size="40">
				Fathers Name:<input type="text" name="dadsName" size="40">
			</fieldset>
			</div>
			<div>
			<fieldset>
				<legend>School Information</legend>
				Name:<input type="text" name="schoolName" size="40"><br>
				Region:<input type="text" name="region" size="40"><br>
			</fieldset>
			</div>
			<fieldset>
				Click here to <input type = submit value = "Submit"> a new prospect 
			</fieldset>
			</div>
		</form>
	</body>
</html>
