
# Array of User Objects
$users = @();

#Import users from csv
function Get-GHUsers {	
	$file = Import-Csv C:\temp\users.csv | foreach {
		$user = [PSCustomObject]@{name = $_.name; desk = $_.desk; x= $_.x; y=$_.y};
		$users += $user;
		Write-Host $users;
	}
}

#Export to csv
function Set-GHUSers {
$user = [PSCustomObject]@{name = $_.Name; desk = $_.Desk; x= $_.X; y=$_.Y};
$user.name="Craig White"; $user.desk="4.11"; $user.x="324"; $user.y="454"
$user | export-csv c:\temp\users.csv
	Write-Host $user;
	}

#TODO : 
#		function that adds users from csv with name, desk, inserts into users array 
#		sorted alphabetically
#		determine what js needs changed, what stays the same
#		format js and html using users array, name, desk, x, y
#		push changes to github

//Get-GHUsers
