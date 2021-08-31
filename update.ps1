
# IMPORT ARRAYLIST - User Objects from CSV
# User Object has Name, Desk, X, Y properties
[System.Collections.ArrayList]$users = Import-CSV ".\users.csv"
$users = $users | Sort-Object -Property Name;

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
    else { Write-Host "$UserName is not on the map!" }
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

  $ArrayList | ForEach-Object {
    if ($UserDesk -eq $_.Desk) {
      if ($_.X -eq "" -or $_.Y -eq "") {
        $desk = $_.Desk;
        Write-Host "Coords not found for desk: $desk!"
      }
      else {
        if ($_.Name -eq "") {
          $user = [PSCustomObject]@{Name = $UserName; Desk = $UserDesk; };
          $ArrayList.Add($user) | Out-Null;
        }
        else {
          $name = $_.Name;
          Write-Host "Desk: $desk is currently occupied by $name!"
        }
      }
    }
  }
  $ArrayList = $ArrayList | Sort-Object -Property Name;
  return $ArrayList;
}

function Add-Spaces {
  param ([Parameter(Mandatory)][int32]$int)
  $spaces = " " * $int;
  return $spaces;
}

# take users and format to Js code
function Format-JS {
  param (
    [Parameter(Mandatory)]$List,
    [Parameter(Mandatory)]$File
  )
  $static = Get-Content .\static.js;
  $snip1 = $static[0..17];
  $snip2 = @(); #Format-JS -List $users
  $snip3 = $static[19..20];

  $List | ForEach-Object {
    $name = $_.Name; $desk = $_.Desk;
    $x = $_.X; $y = $_.Y;
    if ($name -ne "") {
      if ($desk -like "3*") {
        $line = (Add-Spaces 4) + "else if (x == `"$name`")" +
        (Add-Spaces 1) + "{ put_marker($x, $y, `"3rd`"); }";
      }
      else {
        $line = (Add-Spaces 4) + "else if (x == `"$name`")" +
        (Add-Spaces 1) + "{ put_marker($x, $y, `"4th`"); }";
      }
      $snip2 += $line;
    }
  }
  $snippet = $snip1 + $snip2 + $snip3;
  $snippet | out-file $File;
}

$output = ".\output.js"
Format-JS -List $users -File $output;

# Find Coords for Desk#
# $users | ForEach-Object {
#   if ($_.Desk -eq "") { $_.X = ""; $_.Y = ""; }
#   elseif ($_.Desk -eq "") { $_.X = ""; $_.Y = ""; }
#   else { $_.X = ""; $_.Y = ""; }
# }


function Get-Alphabet {
  $chars = @();
  65..90 | ForEach-Object { $chars += [char]$_ };

  $alpha = @();
  for ($i = 0; $i -lt 26; $i++) {
    $alpha += [string]$chars[$i];
  }
  return $alpha;
}

# Format HTML code
$alpha = Get-Alphabet;
$ac = $alpha[0..2];
$dj = $alpha[3..9];
$ko = $alpha[10..14];
$pz = $alpha[15..26];

$index = ".\index.html"
$page2 = ".\page2.html"
$page3 = ".\page3.html"
$page4 = ".\page4.html"

#takes a range of letters, formats names into html code, exports to file
function Format-HTML {
  param (
    [Parameter(Mandatory)]$List,
    [Parameter(Mandatory)]$Range,
    [Parameter(Mandatory)]$File,
    [Parameter(Mandatory)]$Date
  )

  $static = Get-Content .\static.html;
  $snip1 = $static[0..16];
  $snip2 = @();
  $snip3 = $static[18..31];
  $snip4 = (Add-Spaces 4) + "<div class=`"updated`">Updated: $Date</p>"
  $snip5 = $static[33..35];

  for ($i = 0; $i -lt $Range.count; $i++) {
    $List | ForEach-Object {
      $name = $_.Name;
      $pattern = $Range[$i] + "*";
      if ($name -like $pattern) {
        $line = (Add-Spaces 10) + "<option>$name</option>";
        $snip2 += $line;
      }
    } 
  }
  $snippet = $snip1 + $snip2 + $snip3 + $snip4 + $snip5;
  $snippet | out-file $File;
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

Format-HTML -Range $ac -List $users -File $index -Date "8/31"
Format-HTML -Range $dj -List $users -File $page2 -Date "8/31"
Format-HTML -Range $ko -List $users -File $page3 -Date "8/31"
Format-HTML -Range $pz -List $users -File $page4 -Date "8/31"

#TODO :
# DONE: Function that adds users from csv with name, desk, inserts into users ArrayList
#		sorted alphabetically
#		determine what js needs changed, what stays the same
#		format js and html using users array, name, desk, x, y
#		push changes to github

#Set-Users


