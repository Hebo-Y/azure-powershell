# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------

# Warning: This code was generated by a tool.
# 
# Changes to this file may cause incorrect behavior and will be lost if the
# code is regenerated.


function get_vm_config_object
{
    param ([string] $rgname, [string] $vmsize)
    
    $vmname = 'vm' + $rgname;
    $p = New-AzureVMConfig -VMName $vmname -VMSize $vmsize;

    return $p;
}


function get_created_storage_account_name
{
    param ([string] $loc, [string] $rgname)

    $stoname = 'sto' + $rgname;
    $stotype = 'Standard_GRS';

    $st = New-AzureStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type $stotype;
    $st = Get-AzureStorageAccount -ResourceGroupName $rgname -Name $stoname;

    return $stoname;
}


function create_and_setup_nic_ids
{
    param ([string] $loc, [string] $rgname, $vmconfig)

    $subnet = New-AzureVirtualNetworkSubnetConfig -Name ('subnet' + $rgname) -AddressPrefix "10.0.0.0/24";
    $vnet = New-AzureVirtualNetwork -Force -Name ('vnet' + $rgname) -ResourceGroupName $rgname -Location $loc -AddressPrefix "10.0.0.0/16" -DnsServer "10.1.1.1" -Subnet $subnet;
    $vnet = Get-AzureVirtualNetwork -Name ('vnet' + $rgname) -ResourceGroupName $rgname;
    $subnetId = $vnet.Subnets[0].Id;
    $nic_ids = @($null) * 1;
    $nic0 = New-AzureNetworkInterface -Force -Name ('nic0' + $rgname) -ResourceGroupName $rgname -Location $loc -SubnetId $subnetId;
    $nic_ids[0] = $nic0.Id;
    $vmconfig = Add-AzureVMNetworkInterface -VM $vmconfig -Id $nic0.Id -Primary;

    return $nic_ids;
}

function create_and_setup_vm_config_object
{
    param ([string] $loc, [string] $rgname, [string] $vmsize)

    $vmconfig = get_vm_config_object $rgname $vmsize

    $user = "Foo12";
    $password = "BaR#123" + $rgname;
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force;
    $cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword);
    $computerName = "cn" + $rgname;
    $vmconfig = Set-AzureVMOperatingSystem -VM $vmconfig -Windows -ComputerName $computerName -Credential $cred;

    return $vmconfig;
}


function setup_image_and_disks
{
    param ([string] $loc, [string] $rgname, [string] $stoname, $vmconfig)

    $osDiskName = 'osDisk';
    $osDiskVhdUri = "https://$stoname.blob.core.windows.net/test/os.vhd";
    $osDiskCaching = 'ReadWrite';

    $vmconfig = Set-AzureVMOSDisk -VM $vmconfig -Name $osDiskName -VhdUri $osDiskVhdUri -Caching $osDiskCaching -CreateOption FromImage;

    # Image Reference;
    $vmconfig.StorageProfile.SourceImage = $null;
    $imgRef = Get-DefaultCRPImage;
    $vmconfig = ($imgRef | Set-AzureVMSourceImage -VM $vmconfig);

    # TODO: Remove Data Disks for now
    $vmconfig.StorageProfile.DataDisks = $null;

    return $vmconfig;
}


function ps_vm_dynamic_test_func_3_pstestrg1438
{
    # Setup
    $rgname = 'pstestrg1438';

    try
    {
        $loc = 'southeastasia';
        $vmsize = 'Standard_A0';

        $st = New-AzureResourceGroup -Location $loc -Name $rgname;

        $vmconfig = create_and_setup_vm_config_object $loc $rgname $vmsize;

        # Setup Storage Account
        $stoname = get_created_storage_account_name $loc $rgname;

        # Setup Network Interface IDs
        $nicids = create_and_setup_nic_ids $loc $rgname $vmconfig;

        # Setup Image and Disks
        $st = setup_image_and_disks $loc $rgname $stoname $vmconfig;

        # Virtual Machine
        # TODO: Still need to do retry for New-AzureVM for SA, even it's returned in Get-.
        $vmname = 'vm' + $rgname;
        $st = New-AzureVM -ResourceGroupName $rgname -Location $loc -Name $vmname -VM $vmconfig;

        # Get VM
        $vm1 = Get-AzureVM -Name $vmname -ResourceGroupName $rgname;

        # Remove
        $st = Remove-AzureVM -Name $vmname -ResourceGroupName $rgname -Force;
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}

