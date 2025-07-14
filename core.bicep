targetScope = 'resourceGroup'

@description('Name of the Event Hub namespace')
param eventHubNamespaceName string = 'eh-sec-ingest-prod'

@description('Name of the Event Hub')
param eventHubName string = 'vh-defender-json'

@description('Name of the Log Analytics workspace')
param workspaceName string = 'la-sec-ops-prod'

// Event Hub namespace
resource ehNamespace 'Microsoft.EventHub/namespaces@2023-01-01-preview' = {
  name: eventHubNamespaceName
  location: resourceGroup().location
  sku: {
    name: 'Basic'
    tier: 'Basic'
    capacity: 1
  }
}

// Event Hub
resource eh 'Microsoft.EventHub/namespaces/eventhubs@2023-01-01-preview' = {
  name: eventHubName
  parent: ehNamespace
  properties: {
    messageRetentionInDays: 1
    partitionCount: 4
  }
}

// Log Analytics
resource law 'Microsoft.OperationalInsights/workspaces@2023-01-01-preview' = {
  name: workspaceName
  location: resourceGroup().location
  sku: {
    name: 'PerGB2018'
  }
  properties: {
    retentionInDays: 30
  }
}

output eventHubId string = eh.id
output lawId string = law.id
output lawName string = law.name
