targetScope = 'resourceGroup'

@description('Environment name used by azd for resource naming.')
param environmentName string

@description('Azure region for the Static Web App.')
param location string = 'westus2'

@description('Static Web App name override. If empty, a unique name is generated from environmentName + uniqueString(resourceGroup().id).')
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
  ? toLower('swa-${environmentName}-${uniqueString(resourceGroup().id)}')
  : staticSiteName

var effectiveTags = union(tags, {
  'azd-env-name': environmentName
  'azd-service-name': 'web'
})

resource staticSite 'Microsoft.Web/staticSites@2023-01-01' = {
  name: effectiveStaticSiteName
  location: location
  sku: {
    name: sku
  }
  tags: effectiveTags
  properties: {
    // Not linked to a Git provider; azd handles deployment.
    repositoryToken: ''
    buildProperties: {
      appLocation: 'docs'
      outputLocation: '.vitepress/dist'
    }
  }
}

output staticSiteName string = staticSite.name
output staticSiteDefaultHostname string = staticSite.properties.defaultHostname
output staticSiteUrl string = 'https://${staticSite.properties.defaultHostname}'
