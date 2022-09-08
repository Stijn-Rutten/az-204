param(
    [Parameter()]
    [string]$resourceGroupName = 'psdemo-rg'
)

Get-AzResourceGroup -Name $resourceGroupName | Remove-AzResourceGroup -Force