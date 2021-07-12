# Domain Controller check : functions that are helpful for checking DC health in an Active Directory environment
﻿function Check-DCServices {

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