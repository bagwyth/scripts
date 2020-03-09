Login-AzureRmAccount

$subs = Get-AzureRmSubscription

$resources = @()

foreach ($sub in $subs)
{
    Select-AzureRmSubscription $sub
    $subResources = Get-AzureRmResource
    $resources = $resources + $subResources
}

$moveReference = @{}

$moveWebPage = Invoke-WebRequest -UseBasicParsing -Uri https://raw.githubusercontent.com/MicrosoftDocs/azure-docs/master/articles/azure-resource-manager/move-support-resources.md

$splitPage = $moveWebPage.Content.Split('##')

$i = 5

while ($i -le ($splitPage.Length-5))
{
    $section = ($splitPage[$i].Trim()).Split('|')

    $j = 9

    while ($j -le ($section.Length-4))
    {
        $moveReference[$section[0].Trim() + "/" + $section[$j].Trim()] = $section[$j+1].Trim(), $section[$j+2].Trim()
        $j = $j+4
    }

    $i = $i+2
}

foreach ($resource in $resources)
{
    Write-Host "Resource Name: " $resource.Name
    Write-Host "Resource Group: " $resource.ResourceGroupName
    Write-host "Resource Type: " $resource.ResourceType
    Write-Host "Can move resource groups: " $moveReference.($resource.ResourceType)[0]
    Write-Host "Can move subscriptions: " $moveReference.($resource.ResourceType)[1]
    Write-Host ""
}