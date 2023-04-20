PARAM ($SPN = ("HOST/" + $env:COMPUTERNAME))
#************************************************
# FindSPNsInForest.ps1
# Version 1.0
# Date: 4-28-2015
# Author: Tim Springston
# Script to take a SPN string and query the local forest for all instance of it.
#************************************************
cls
$SPNResults = $pwd.Path + "\SPNChecks.txt"

function GetADObjectfromSPN
    {
	param ([string]$SPN)
	$ForestInfo = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
	$RootString = "GC://" + $ForestInfo.Name
	$Root = New-Object  System.DirectoryServices.DirectoryEntry($RootString)
	$searcher = New-Object DirectoryServices.DirectorySearcher($Root)
	$searcher.Filter="(serviceprincipalname=$spn)"
	[System.DirectoryServices.SearchResultCollection]$results=$searcher.findall()
	return $results
	}
$Results = GetADObjectfromSPN $SPN

(Get-Date)  | Out-file  -FilePath $SPNResults -Encoding utf8
(Get-Date)  | Out-Host 
"SPN Search Results for: $spn" | out-file -FilePath  $SPNResults -Append -Encoding utf8
"SPN Search Results for: $spn" | Out-Host
$Forest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
"Searched forest: $Forest" | out-file -FilePath  $SPNResults -Append -Encoding utf8
"Searched forest: $Forest" | Out-Host
$Count = $Results.Count
"Number of objects returned: $Count" | out-file -FilePath  $SPNResults -Append -Encoding utf8
"Number of objects returned: $Count" | Out-Host
"****************************"	 | out-file -FilePath  $SPNResults -Append -Encoding utf8
"****************************" | Out-Host
	 foreach ($result in $Results)
	{
	$DN = $result.properties.distinguishedname
	"DN of object: $DN" | out-file -FilePath  $SPNResults -Append -Encoding utf8
	"DN of object: $DN" | Out-Host
	$SPNs = $Result.properties.serviceprincipalname
	"SPNs are: $SPNs " | out-file -FilePath  $SPNResults -Append -Encoding utf8
	"SPNs are: $SPNs "| Out-Host
	"  " | out-file -FilePath  $SPNResults -Append -Encoding utf8
	"  "  | Out-Host
	}
