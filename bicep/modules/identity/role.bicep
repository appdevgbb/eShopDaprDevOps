param principalId string
param roleGuid string
param vnetName string
param subnetName string

resource existingvnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing =  {
  name: vnetName
}
resource existingAksSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-08-01' existing = {
  parent: existingvnet
  name: subnetName
}

resource role_assignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(subscription().id, principalId)
  scope: existingAksSubnet
  properties: {
    principalId: principalId
    roleDefinitionId: roleGuid
    principalType: 'ServicePrincipal'
  }
}
