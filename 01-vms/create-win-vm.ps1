$username = 'demoadmin'
$password = ConvertTo-SecureString 'p@ssword123!' -AsPlainText -Force

$WindowsCred = New-Object System.Management.Automation.PSCredential ($username, $password)
$location = 'westeurope'
$resourceGroupName = 'psdemo-rg'
$vmName = 'psdemo-win-ps'

New-AzResourceGroup	`
    -Name $resourceGroupName `
    -Location $location

New-AzVM `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -Image 'Win2019Datacenter' `
    -Credential $WindowsCred `
    -OpenPorts 3389 `
    -Name $vmName


Get-AzPublicIpAddress `
    -ResourceGroupName $resourceGroupName `
    -Name $vmName | Select-Object IpAddress