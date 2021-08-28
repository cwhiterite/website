


# IMPORT ARRAYLIST - User Objects from CSV
# User Object has Name, Desk, X, Y properties
[System.Collections.ArrayList]$users = Import-CSV "C:\temp\users.csv"

# EXPORT ARRAYLIST - User Objects to CSV
# User Object has Name, Desk, X, Y properties
$users | Export-Csv C:\temp\users.csv -NoTypeInformation

# REMOVES USER - By Name from Cloned Arraylist, Returns Clone
# Assigned variable needs to be statically typed as an ArrayList
# [System.Collections.ArrayList]$? = Remove-User -UserName "?" -UserList "?"
function Remove-User {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]$UserName,
		[Parameter(Mandatory)]$UserList
	)

	$ArrayList = $UserList.Clone();

	for ($i = 0; $i -lt $ArrayList.Count; $i++) {
		if ($ArrayList[$i].Name -eq $UserName) {
			$ArrayList.RemoveAt($i);
		}
	}
	$ArrayList = $ArrayList | Sort-Object -Property Name;
	return $ArrayList;
}

# ADDS USER - By Name to Cloned ArrayList, Sorts, Returns Clone
# Assigned variable needs to be statically typed as an ArrayList 
# [System.Collections.ArrayList]$? = Add-User -UserName "?" -UserDesk "?" -UserList "?"
function Add-User {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]$UserName,
		[Parameter(Mandatory)]$UserDesk,
		[Parameter(Mandatory)]$UserList
	)

	$ArrayList = $UserList.Clone();

	$user = [PSCustomObject]@{
		Name = $UserName; Desk = $UserDesk; X = "0"; Y = "0" 
 };
	$ArrayList.Add($user) | Out-Null;
	$ArrayList = $ArrayList | Sort-Object -Property Name;
	return $ArrayList;
}

# take users and format to Js code
function Format-UsersJS {
	param ([Parameter(Mandatory)]$UserList)
	$string = @()
	$UserList | ForEach-Object {
		$name = $_.Name; $x = $_.X; $y = $_.Y;
		$line = "    else if (x == `"$name`")`n"+
		"    { coordinates = [($x,$y];"+
		" put_marker(coordinates[0], coordinates[1],"+
		" `"4th`"); }";
		$string += $line;
	}
	return $string;
}

# Get static js code and then insert users
$static = Get-Content .\static.js;
$snip1 = $static[0..17];
$snip3 = $static[19..21];
$snip2 = Format-Users
$snippet = $snip1+$snip2+$snip3;

#export code to JS file
$snippet | out-file .\output.js



# Find Coords for Desk#
$users | ForEach-Object {
	if ($_.Desk -eq "") {$_.X="";$_.Y="";}
	elseif ($_.Desk -eq "") {$_.X="";$_.Y="";}
	else {$_.X="";$_.Y="";}
}


# Format HTML code

function Format-UsersHTML {
	param ([Parameter(Mandatory)]$UserList)
	$string = @()
	$UserList | ForEach-Object {
		$name = $_.Name;
		# Find Ranges of Names by First Initial
		switch ($name) {
			condition {}
		}
		$line = "                    <option>$name</option>";
		$string += $line;
	}
	return $string;
	
}
















#Import users from csv
function Get-Users {	
	Import-Csv C:\temp\users.csv | ForEach-Object {
		$user = [PSCustomObject]@{name = $_.name; desk = $_.desk; x = $_.x; y = $_.y };
		$users += $user;
		Write-Host $users;
	}
}

#Export to csv
function Set-Users {
	$user = [PSCustomObject]@{name = $_.Name; desk = $_.Desk; x = $_.X; y = $_.Y };
	$user.name = "Craig White"; $user.desk = "4.11"; $user.x = "324"; $user.y = "454";
	$user | export-csv c:\temp\users.csv -NoTypeInformation
	Write-Host $user;
}

#TODO : 
# DONE: Function that adds users from csv with name, desk, inserts into users ArrayList 
#		sorted alphabetically
#		determine what js needs changed, what stays the same
#		format js and html using users array, name, desk, x, y
#		push changes to github

#Set-Users

