targetScope = 'managementGroup'
extension microsoftGraph

// How to Deploy this Bicep File - Management Group Target
// az deployment mg create --location eastus --management-group-id Production_MG --template-file main.bicep 

param suffix string

// Lookup the built-in Contributor role definition
@description('This is the built-in Contributor role. See https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#contributor')
resource contributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
}

// TODO: pass this in as a parameter
var roleDefName = guid('Helix_Developer_Role')


// Create a new role definition based on Contributor Role
resource programDeveloperRole 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' = {
  name: roleDefName
  properties: {
    assignableScopes: [
      managementGroup().id
    ]
    description: 'Lorem Impsum'
    permissions: contributorRoleDefinition.properties.permissions
    // TODO: pass this in as a parameter
    roleName: 'Helix_Developer_Role'
    type: 'customRole'
  }
}

// Lookup existing EntraID Group
resource programGroup 'Microsoft.Graph/groups@v1.0' existing =  {
  // TODO: pass this in as a parameter
  uniqueName: 'helix_Developer_Group'
}

// Assing the program role to the program group
resource programRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(managementGroup().id, programDeveloperRole.id) 
   properties: {
    roleDefinitionId: programDeveloperRole.id
    principalId: programGroup.id
    principalType: 'Group'
  }
}
