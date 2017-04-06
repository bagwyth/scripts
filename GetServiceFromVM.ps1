$rg = "vs2017"
$vm = "bhvs2017"
$svc = "w32time"

Set-AzureRmVMCustomScriptExtension -ResourceGroupName $rg `
                                   -VMName $vm `
                                   -FileUri "https://raw.githubusercontent.com/bhummerstone/Powershell/master/getservice.ps1" `
                                   -Name "getservice" `
                                   -Location "westeurope" `
                                   -Run "getservice.ps1" `
                                   -Argument $svc 


$output = Get-AzureRmVMDiagnosticsExtension -ResourceGroupName $rg -VMname $vm -Name "getservice" -Status
$output.SubStatuses[0]