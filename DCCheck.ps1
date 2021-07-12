
function Check-DCServices {

param(
[String] $Computer

)


$RequiredSvc = @("ADWS","DFSR","DNS","Dnscache","gpsvc","Kdc","Netlogon","NTDS","w32time")

$FailedServices = @{}

$RequiredSvc | Foreach-Object { 
$flag = $null
$flag = Get-Service $_ -ComputerName $Computer | Where-Object {$_.Status -ne "running"}  

if ($flag -ne $null)
{
$FailedServices.Add($_,$flag.Status)

}

 } 

 if ($FailedServices.Count -eq 0) { return $true }
 else {return $FailedServices }
 }


 function Check-DCConnectivity {

 param(
 [String]$DC
 )

 Invoke-Command -ComputerName $DC -ScriptBlock {Get-ADDomain | Select -ExpandProperty ReplicaDirectoryServers | Foreach-object {if ((Test-Connection $_ -Count 1 -Quiet) -ne $true) {Write-Host -ForegroundColor Red "$env:COMPUTERNAME --> $_ Failure"}}}

 
 }