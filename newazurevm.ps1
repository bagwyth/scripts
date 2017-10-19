Login-AzureRmAccount

$rg = New-AzureRmResourceGroup -Name bhvmtest -Location uksouth

$subnet = New-AzureRmVirtualNetworkSubnetConfig -Name default -AddressPrefix 192.168.0.0/24

$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location -Name bhbnettest -AddressPrefix 192.168.0.0/16 -Subnet $subnet

$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name nsgRDP -Protocol Tcp -Direction Inbound -Priority 1001 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 -Access Allow

$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location -Name bhnsgtest -SecurityRules $nsgRuleRDP

$nic = New-AzureRmNetworkInterface -Name bhvnic01 -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location -SubnetId $vnet.Subnets[0].Id -NetworkSecurityGroupId $nsg.Id

$vmconfig = New-AzureRmVMConfig -VMName bhvmtest -VMSize Standard_DS2_v2 | Set-AzureRmVMOperatingSystem -Windows -ComputerName bhvmtest -Credential (Get-Credential) | Set-AzureRmVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2016-Datacenter -Version latest | Add-AzureRmVMNetworkInterface -Id $nic.Id

$vm = New-AzureRmVM -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location -VM $vmconfig