targetScope = 'resourceGroup'

module core './core.bicep' = {
  name: 'coreInfra'
  params: {
    eventHubNamespaceName: 'eh-sec-ingest-prod'
    eventHubName: 'vh-defender-json'
    workspaceName: 'la-sec-ops-prod'
  }
}
