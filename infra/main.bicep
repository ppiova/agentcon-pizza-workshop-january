targetScope = 'resourceGroup'

@description('Azure region for the Static Web App.')
param location string = 'westus'

@description('Optional name prefix used to generate a globally-unique Static Web App name when staticSiteName is empty.')
param namePrefix string = 'swa-agentcon-pizza-workshop'

@description('Static Web App name override. If empty, a unique name is generated from namePrefix + uniqueString(resourceGroup().id).')
param staticSiteName string = ''

@description('SKU for Azure Static Web Apps.')
@allowed([
  'Free'
  'Standard'
])
param sku string = 'Free'

@description('Optional tags to apply to the resource.')
param tags object = {}

var effectiveStaticSiteName = empty(staticSiteName)
  ? toLower('${namePrefix}-${uniqueString(resourceGroup().id)}')
  : staticSiteName

// NOTE:
// This Bicep creates ONLY the Azure Static Web App resource.
// It does NOT (and cannot, by itself) create GitHub repository secrets.
//
// After deployment:
// 1) Take the output "deploymentToken" and add it to your GitHub repo as a secret named:
//      AZURE_STATIC_WEB_APPS_API_TOKEN
// 2) Run the GitHub Actions workflow in this repo.

resource staticSite 'Microsoft.Web/staticSites@2023-01-01' = {
  name: effectiveStaticSiteName
  location: location
  sku: {
    name: sku
  }
  tags: tags
  properties: {}
}

// Static Web Apps exposes the deployment token via listSecrets.
// The response is a StringDictionary: { properties: { apiKey: '<token>' } }
var staticSiteSecrets = listSecrets(staticSite.id, staticSite.apiVersion)

output staticSiteName string = staticSite.name
output staticSiteDefaultHostname string = staticSite.properties.defaultHostname
output staticSiteUrl string = 'https://${staticSite.properties.defaultHostname}'

@secure()
output deploymentToken string = staticSiteSecrets.properties.apiKey
