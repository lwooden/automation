param location string
param storageAccountName string
param containerName string



resource baseStorageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'BlobStorage'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
  }
}

// This resource functions like a storage "client" which allows me to perform operations against the storage account
// e.g creating a container the storage account
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: baseStorageAccount
  properties: {}
}

resource baseContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: containerName
  parent: blobService
  properties: {
    defaultEncryptionScope: ''
    metadata: {}
    publicAccess: 'None'  
  }
}
