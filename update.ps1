

[System.Collections.ArrayList]$users = Import-CSV ".\users.csv"
$users = $users | Sort-Object -Property Name;

$users | Export-Csv C:\temp\users.csv -NoTypeInformation



# [System.Collections.ArrayList]$? = 
# Remove-User -UserName "?" -UserList "?"
function Remove-Name {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]$Name,
    [Parameter(Mandatory)]$List
  )

  $ArrayList = $List.Clone();

  $ArrayList | ForEach-Object {
    if ($_.Name -eq $Name) { $_.Name = ""; }
    else { Write-Host "$Name is not on the map!" }
  } 
  $ArrayList = $ArrayList | Sort-Object -Property Name;
  return $ArrayList;
}

# [System.Collections.ArrayList]$? = 
# Add-User -UserName "?" -UserDesk "?" -UserList "?"
function Add-Name {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]$Name,
    [Parameter(Mandatory)]$Desk,
    [Parameter(Mandatory)]$List
  )
  $ArrayList = $List.Clone();

  $ArrayList | ForEach-Object {
    if ($Desk -eq $_.Desk) {
      if ($_.X -eq "" -or $_.Y -eq "") {
        $d = $_.Desk;
        Write-Host "Coords not found for desk: $d!"
      }
      else {
        if ($_.Name -eq "") { $_.Name = $Name; }
        else {
          $n = $_.Name;
          Write-Host "Desk: $d is currently occupied by $n!"
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




function Get-Alphabet {
  $chars = @();
  65..90 | ForEach-Object { $chars += [char]$_ };

  $alpha = @();
  for ($i = 0; $i -lt 26; $i++) {
    $alpha += [string]$chars[$i];
  }
  return $alpha;
}

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



[System.Collections.ArrayList]$users = Import-CSV ".\users.csv"
$users = $users | Sort-Object -Property Name;

$users | Export-Csv C:\temp\users.csv -NoTypeInformation

$output = ".\javascript.js"
Format-JS -List $users -File $output;

$alpha = Get-Alphabet;
$ac = $alpha[0..2];
$dj = $alpha[3..9];
$ko = $alpha[10..14];
$pz = $alpha[15..26];

$index = ".\index.html"
$page2 = ".\page2.html"
$page3 = ".\page3.html"
$page4 = ".\page4.html"

Format-HTML -Range $ac -List $users -File $index -Date "9/1"
Format-HTML -Range $dj -List $users -File $page2 -Date "9/1"
Format-HTML -Range $ko -List $users -File $page3 -Date "9/1"
Format-HTML -Range $pz -List $users -File $page4 -Date "9/1"

#TODO :
#		push changes to github








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



