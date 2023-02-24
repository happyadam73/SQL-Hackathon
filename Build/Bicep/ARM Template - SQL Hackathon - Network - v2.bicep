param location string = resourceGroup().location
var virtualNetworkName = '${resourceGroup().name}-vnet'
var storageAccountName = 'sqlhacksa${uniqueString(resourceGroup().id)}'
var addressPrefix = '10.0.0.0/16'
var MIsubnetName = 'ManagedInstance'
var MIsubnetPrefix = '10.0.1.0/24'
var GatewaySubnetName = 'GatewaySubnet'
var GatewaySubnetPrefix = '10.0.0.0/24'
var ManagementSubnetName = 'Management'
var ManagementSubnetPrefix = '10.0.2.0/24'
var TeamVMSubnetName = 'TeamJumpServers'
var TeamVMSubnetPrefix = '10.0.3.0/24'

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          enabled: true
        }
        blob: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-04-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: GatewaySubnetName
        properties: {
          addressPrefix: GatewaySubnetPrefix
        }
      }
      {
        name: MIsubnetName
        properties: {
          addressPrefix: MIsubnetPrefix
        }
      }
      {
        name: ManagementSubnetName
        properties: {
          addressPrefix: ManagementSubnetPrefix
        }
      }
      {
        name: TeamVMSubnetName
        properties: {
          addressPrefix: TeamVMSubnetPrefix
        }
      }
    ]
  }
  dependsOn: []
}
