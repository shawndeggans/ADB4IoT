// Target Scope 
targetScope = 'resourceGroup'

// parameters length changed to 12 from 9
@minLength(3)
@maxLength(12)
@description('3-9 lowercase character name/ID of applicaiton. Can only contain letters, no numbers, symbols, or spaces')
param shortName string

@allowed([
    'd'
    'q'
    't'
    'p'
])
@description('Environment code for the application. See shared-environment-codes.json for a list of codes')
param environmentCode string

@description('Two digit, zero padded resource sequence number (e.g 01,02,03). Defaults to 01')
@minLength(2)
@maxLength(2)
param appSequence string

param sku string = 'premium'

@description('The Azure location/data center to deploy to. Defaults to (and only allows) eastus2')
param location string = 'southcentralus'

var regionPrefix = ((location == 'southcentralus') ? 'scus' : '')

var dataBricksWorkspaceName = '${regionPrefix}${shortName}wsdb${environmentCode}${appSequence}'

//This represents the managed resource group that databricks creates
var managedResourceGroupName = 'databricks-rg-${dataBricksWorkspaceName}-${uniqueString(dataBricksWorkspaceName, resourceGroup().id)}'

// A configuration file is used to pass values to modules
// we pass everything we need here to build out the resource names
// tags, and other information needed at the module level
var config = {
  shortName: shortName
  environmentCode: environmentCode
  appSequence: appSequence
  regionPrefix: regionPrefix
  location: location
  tags: resourceGroup().tags
  tenantId: subscription().tenantId
  dataBricksWorkspaceName: dataBricksWorkspaceName
  sku: sku
  managedResourceGroupName: managedResourceGroupName
}

resource dataBricks 'Microsoft.Databricks/workspaces@2021-04-01-preview' = {
  name: config.dataBricksWorkspaceName
  location: config.location
  sku: {
    name: config.sku
  }
  properties: {
    managedResourceGroupId: subscriptionResourceId('Microsoft.Resources/resourceGroups', managedResourceGroupName)
  }
}


