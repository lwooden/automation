param location string
param vaultName string
param vaultSkuName string 
param vaultSkuTier string


resource recoveryServicesVault 'Microsoft.RecoveryServices/vaults@2021-07-01' = {
  name: vaultName
  location: location
  sku: {
    name: vaultSkuName
    tier: vaultSkuTier
  }
  properties: {}
}
