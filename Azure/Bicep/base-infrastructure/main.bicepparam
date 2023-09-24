using './main.bicep'

param suffix = '-rg'

param location = 'eastus'
param resourceGroupName = 'base-infra'

param projectName = 'helix'
param environment = 'devtest'

param vnetCidr = '10.0.0.0/16'
param privateSubnet1Cidr = '10.0.1.0/24'
param privateSubnet2Cidr = '10.0.2.0/24'
param publicSubnet1Cidr = '10.0.3.0/24'
param publicSubnet2Cidr = '10.0.4.0/24'

param storageAccountName = 'sa'
param containerName = 'cloud-team'

param allocatedFundAmount = 150
param budgetStartDate = '2023-09-01'
param budgetEndDate = '2024-09-30'
param budgetContactEmails = ['lowell.wooden@gmail.com']

param logAnalyticsWorkspaceSku = 'PerGB2018'
param retentionInDays = 30

param vaultStorageRedundancy = 'LocallyRedundant'

param vaultSkuName = 'RS0'
param vaultSkuTier =  'Standard'

