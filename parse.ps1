
# PARSES JS CODE AND CREATES USER OBJECTS 
# OBJECTS HAVE NAME, DESK, X COORD, & Y COORD

#get string data from file
$file = Get-Content -Path c:\users\cwhite\desktop\userList2.txt;

#each line is an object in array
$file.Split("`n");

#parse name
$names = $file | ForEach-Object {
	$a = $_.replace("else if (x == `"", "");
	$b = $a.split("`"");
	return $b[0];
}

#parse xcoord
$xcoords = $file | ForEach-Object {
	$a = $_.split("``[");
	$b = $a[1].split(",");
	return $b[0];
}

#parse ycoord
$ycoords = $file | ForEach-Object {
	$a = $_.split(",");
	$b = $a.trim();
	$c = $b[1].split("``]");
	return $c[0];
}

#parse desks
$desks = $file | ForEach-Object {
	if ($_ -like "*3rd*") { return "3" }
	else { return "4" }
}

#create array of users with name, x,y, desk
$users = [System.Collections.ArrayList]@();

for ($i = 0; $i -lt $desks.count; $i++) {
 $user = [PSCustomObject]@{Name = $names[$i]; Desk = $desks[$i]; X = $xcoords[$i]; Y = $ycoords[$i] };
	$users.Add($user) | Out-Null;
}