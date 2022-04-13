$vms = az vm list -g RG-AKS-DEVSECOPS | ConvertFrom-Json 

foreach ($vm in $vms) {    
    Write-Output $vm.name    
    $ip = az vm show -g RG-AKS-DEVSECOPS -n $vm.name -d --query privateIps -otsv
    Write-Output $ip
}