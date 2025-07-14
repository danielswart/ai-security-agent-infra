targetScope = 'resourceGroup'

@description('Name of the Data Collection Rule')
param dcrName string

@description('Name of the existing Log Analytics workspace')
param workspaceName string

@description('Location for the DCR')
param location string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-01-01-preview' existing = {
  name: workspaceName
}

resource dcr 'Microsoft.Insights/dataCollectionRules@2021-09-01-preview' = {
  name: dcrName
  location: location
  kind: 'Windows'
  properties: {
    dataSources: {
      performanceCounters: [
        {
          name: 'cpuPerf'
          counterSpecifiers: ['\\Processor(_Total)\\% Processor Time']
          samplingFrequencyInSeconds: 15
          streams: ['Microsoft-Perf']
        }
      ]
      heartbeat: [
        {
          name: 'heartbeat1'
          streams: ['Microsoft-Heartbeat']
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          name: 'laDest'
          workspaceResourceId: logAnalytics.id
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Microsoft-Perf', 'Microsoft-Heartbeat']
        destinations: ['laDest']
      }
    ]
  }
}

output dcrId string = dcr.id
