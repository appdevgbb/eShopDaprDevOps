param location string

param ubuntuVersion string
param vmSize string

@secure()
param adminUsername string

@secure()
param adminPassword string

param subnetId string

var numberOfSelfRunners = 2

resource pip 'Microsoft.Network/publicIPAddresses@2021-05-01' = [for i in range(0, numberOfSelfRunners): {
  name: 'pip-runner-${i}'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    publicIPAddressVersion: 'IPv4'
  }
}]

resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = [for i in range(0, numberOfSelfRunners): {
  name: 'runner-${i}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig-runner'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip[i].id
          }
        }
      }
    ]
  }
}]

resource vm 'Microsoft.Compute/virtualMachines@2020-06-01' = [for i in range(0, numberOfSelfRunners): {
  name: 'runner-${i}'
  location: location
  tags: {
    'Lifecycle': 'runner'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {    
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: ubuntuVersion
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic[i].id
        }
      ]
    }
    osProfile: {
      computerName: 'runner-${i}'
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {        
        patchSettings: {
          patchMode: 'ImageDefault'
        }
      }
      customData: loadFileAsBase64('jumpbox-cloud-init.yaml')
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}]


output runnerVmInfo array = [for i in range(0, numberOfSelfRunners): {
  vmName: vm[i].name
  privateIp: nic[i].properties.ipConfigurations[0].properties.privateIPAddress
  jumpboxname: vm[i].name
}]

output privateIps array = [for i in range(0, numberOfSelfRunners): {  
  privateIp: nic[i].properties.ipConfigurations[0].properties.privateIPAddress  
}]
