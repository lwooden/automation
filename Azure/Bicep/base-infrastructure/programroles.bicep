extension microsoftGraph

// Lookup the built-in Contributor role definition
// @description('This is the built-in Contributor role. See https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#contributor')
// resource contributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
//   scope: subscription()
//   name: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
// }

var roleDefName = guid('Helix_Developer_Role')

// Create a new role definition based on Contributor Role
resource programDeveloperRole 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' = {
  name: roleDefName
  properties: {
    assignableScopes: [
      '/providers/Microsoft.Management/managementGroups/Production_MG'
    ]
    description: 'Lorem Impsum'
    permissions: [
      {
  actions: [
    '*'
  ]
  notActions: [
    'Microsoft.Authorization/*/Delete'
    'Microsoft.Authorization/*/Write'
    'Microsoft.Authorization/elevateAccess/Action'
    'Microsoft.Blueprint/blueprintAssignments/write'
    'Microsoft.Blueprint/blueprintAssignments/delete'
    'Microsoft.Compute/galleries/share/action'
    'Microsoft.Purview/consents/write'
    'Microsoft.Purview/consents/delete'
    'Microsoft.Resources/deploymentStacks/manageDenySetting/action'
  ]
  dataActions: []
  notDataActions: []
}
    ]
    roleName: 'Helix_Developer_Role'
    type: 'customRole'
  }
}

// Lookup existing EntraID Group
resource programGroup 'Microsoft.Graph/groups@v1.0' existing =  {
  uniqueName: 'helix_Developer_Group'
}

// Assing the program role to the program group
resource programRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, programDeveloperRole.id) 
   properties: {
    roleDefinitionId: programDeveloperRole.id
    principalId: programGroup.id
    principalType: 'Group'
  }
}
