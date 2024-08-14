targetScope='subscription'



// ---- Foundational infrastructure for every subscription -----
// VNET + Subnets + Route Tables + Routes + Custom DNS Servers ✅ 
// Storage Account w/ Container ✅
// Budget w/ Action Group ✅
// Log Analytics Workspace ✅
// Recovery Services Vault ✅

// How to Deploy this Bicep File - Subscription Target
// az deployment sub create --location eastus --template-file main.bicep --parameters main.bicepparam

// Parameters
// NOTE: Actual values are set and passed in from the project parameter file --> main.bicepparam
param suffix string

param resourceGroupName string
param location string
param projectName string
param environment string

param vnetCidr string
param privateSubnet1Cidr string
param privateSubnet2Cidr string
param publicSubnet1Cidr string
param publicSubnet2Cidr string

param storageAccountName string
param containerName string

param allocatedFundAmount int
param budgetStartDate string
param budgetEndDate string
param budgetContactEmails array


@allowed([
  'PerGB2018'
  'Free'
  'Standalone'
  'PerNode'
  'Standard'
  'Premium'
])
param logAnalyticsWorkspaceSku string

@description('The workspace data retention in days. Allowed values are per pricing plan. See pricing tiers documentation for details.')

@minValue(7)
@maxValue(730)
param retentionInDays int


@allowed([
  'LocallyRedundant'
  'GeoRedundant'
])
param vaultStorageRedundancy string

param vaultSkuName string 
param vaultSkuTier string


resource baseResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${resourceGroupName}${suffix}'
  location: location
}


//TODO: remove this
// resource budgetResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
//   name: 'budget-rg'
//   location: location
// }


// module baseVirtualNetwork 'vnet.bicep' = {
//   name: 'vnetModule'
//   scope: baseResourceGroup
//   params: {
//     location: location
//     projectName: projectName
//     environment: environment
//     vnetCidr: vnetCidr
//     privateSubnet1Cidr: privateSubnet1Cidr
//     privateSubnet2Cidr: privateSubnet2Cidr
//     publicSubnet1Cidr: publicSubnet1Cidr
//     publicSubnet2Cidr: publicSubnet2Cidr
//     natGatewayName: '${projectName}-${environment}-nat-gateway'
//   }
// }


module  baseStorageAccount 'storageaccount.bicep' = {
  name: 'storageModule'
  scope: baseResourceGroup
  params: {
    location: location
    storageAccountName: '${projectName}${environment}${storageAccountName}'
    containerName: containerName
  } 
}

// module  baseLogAnalysticsWorkspace 'loganalytics.bicep' = {
//   name: 'logAnalyticsModule'
//   scope: baseResourceGroup
//   params: {
//     location: location
//     logAnalyticsWorkspaceName: '${projectName}-${environment}-workspace'
//     logAnalyticsWorkspaceSku: logAnalyticsWorkspaceSku
//     retentionInDays: retentionInDays
//   } 
// }

// module  baseRecoveryServicesVault 'recoveryservicesvault.bicep' = {
//   name: 'recoveryServicesVaultModule'
//   scope: baseResourceGroup
//   params: {
//     location: location
//     vaultName: '${projectName}-${environment}-vault'
//     vaultSkuName: vaultSkuName
//     vaultSkuTier:  vaultSkuTier
//   } 
// }



// Budget -- Subscripton Level Deployment
// TODO: integrate notifications w/ action groups versus basic contact email list
// resource baseBudget 'Microsoft.CostManagement/budgets@2019-04-01-preview' = {
//   name: '${projectName}-${environment}-budget'
//   scope: subscription()
//   properties: {
//     amount: allocatedFundAmount
//     category: 'Cost'
//     filter: {}
//     notifications: {
//       Exceeded50PercentofBudget: {
//         enabled: true
//         operator: 'GreaterThan'
//         threshold: 50
//         contactEmails: budgetContactEmails
//       }
//       Exceeded75PercentofBudget: {
//         enabled: true
//         operator: 'GreaterThan'
//         threshold: 75
//         contactEmails: budgetContactEmails
//       }
//       Exceeded90PercentofBudget: {
//         enabled: true
//         operator: 'GreaterThan'
//         threshold: 90
//         contactEmails: budgetContactEmails
//       }
//     }
//     timeGrain: 'Annually'
//     timePeriod: {
//       endDate: budgetEndDate
//       startDate: budgetStartDate
//   }
//  }
// }

module  baseProgramEntraIDGroups 'programgroups.bicep' = {
  name: 'groupsModule'
  scope: baseResourceGroup
  params: {
    projectName: projectName
  } 
}







