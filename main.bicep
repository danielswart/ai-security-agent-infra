targetScope = 'resourceGroup'

@description('Name of the Event Hub namespace')
param eventHubNamespaceName string = 'eh-sec-ingest-prod'

@description('Name of the Event Hub')
param eventHubName string = 'vh-defender-json'

@description('Name of the Log Analytics workspace')
param workspaceName string = 'la-sec-ops-prod'

@description('Name of the Data Collection Rule')
param dcrName string = 'dcr-sec-ingest'

@description('Name of the target VM')
param vmName string = 'vm-win-01'

// Core Infra Module
module core './core.bicep' = {
  name: 'coreInfra'
  params: {
    eventHubNamespaceName: eventHubNamespaceName
    eventHubName: eventHubName
    workspaceName: workspaceName
  }
}

// DCR Module
module dcr './dcr.bicep' = {
  name: 'dcrModule'
  params: {
    dcrName: dcrName
    workspaceName: workspaceName
    location: resourceGroup().location
  }
}

// Reference existing VM for DCR association
resource vmResource 'Microsoft.Compute/virtualMachines@2022-11-01' existing = {
  name: vmName
}

// DCR association with VM
resource dcrAssociation 'Microsoft.Insights/dataCollectionRuleAssociations@2021-09-01-preview' = {
  name: 'dcr-to-vm'
  scope: vmResource
  properties: {
    dataCollectionRuleId: dcr.outputs.dcrId
  }
}
