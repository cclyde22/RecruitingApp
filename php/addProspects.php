<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		</script>
		<script type="text/javascript" src="../js/jquery-1.4.2.min.js"></script>
		<script type="text/javascript" src="../js/jquery-dynamic-form.js"></script>
		<script type="text/javascript">
			$(document).ready(function(){
				var mainDynamicForm = $("#prospect").dynamicForm("#plus", "#minus", {
					limit:5
				});
			});
		</script>
	</head>
	<body>
	<h1>Add Prospect</h1>
 	<hr>
	<div id = 'prospect'>
		<form method="post" action="insertProspects.php">
			<h2>Personal</h2>
			Name:<input type="text" name="name" size="40"><br>
			Position:<input type="text" name="position" size="40"><br>
			Jersey Number:<input type="text" name="jerseyNo" size="2"><br>
			Grad Year:<input type="text" name="year" size="4"><br>
			Height:<input type="text" name="height" size="6"><br>
			Weight:<input type="text" name="weight" size="4"><br>
			Evaluation:<input type="text" name="level" size="8"><br>
			<h2>Contact</h2>
			Cell:<input type="text" name="cellNo" size="10"><br>
			Home Phone:<input type="text" name="homeNo" size="10"><br>
			Email:<input type="text" name="email" size="40"><br>
			Address:<input type="text" name="address" size="100"><br>
			Mothers Name:<input type="text" name="momsName" size="40"><br>
			Fathers Name:<input type="text" name="dadsName" size="40"><br>
			<h2>School</h2>
			Name:<input type="text" name="schoolName" size="40"><br>
			Region:<input type="text" name="region" size="40"><br>
	</div>
			<div><a id="minus" href="">[-]</a> <a id="plus" href="">[+]</a></div>
			<br>
      <input type="submit" />
		</form>
	</body>
</html>
