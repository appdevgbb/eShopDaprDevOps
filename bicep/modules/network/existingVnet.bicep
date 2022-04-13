param vnetName string


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetName
}

output vnetId string = virtualNetwork.id
output virtualNetworkName string = virtualNetwork.name
output jumpboxSubnetId string = virtualNetwork.properties.subnets[1].id
output prvEndpointSubnetId string = virtualNetwork.properties.subnets[2].id
output aksSubnetName string = virtualNetwork.properties.subnets[0].name
output aksSubnetId string = virtualNetwork.properties.subnets[0].id
