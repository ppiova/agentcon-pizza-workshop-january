targetScope = 'subscription'

@description('Azure region for the Resource Group and Static Web App.')
param location string

@description('Resource Group name to create/use (idempotent).')
param resourceGroupName string

@description('Optional name prefix used to generate a globally-unique Static Web App name when staticSiteName is empty.')
param namePrefix string = 'swa-agentcon-pizza-workshop'

@description('Static Web App name override. If empty, a unique name is generated from namePrefix + uniqueString(resourceGroupName).')
param staticSiteName string = ''

@description('SKU for Azure Static Web Apps.')
@allowed([
  'Free'
  'Standard'
])
param sku string = 'Free'

@description('Optional tags to apply to the resource.')
param tags object = {}

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

module swa './main.bicep' = {
  name: 'swaDeploy'
  scope: rg
  params: {
    location: location
    namePrefix: namePrefix
    staticSiteName: staticSiteName
    sku: sku
    tags: tags
  }
}

output resourceGroupName string = rg.name
output staticSiteName string = swa.outputs.staticSiteName
output staticSiteUrl string = swa.outputs.staticSiteUrl

@secure()
output deploymentToken string = swa.outputs.deploymentToken
