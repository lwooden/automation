extension microsoftGraph

param projectName string
param suffix1 string = '_Developer_Group'
param suffix2 string = '_Reader_Group'

resource programDeveloperGroup 'Microsoft.Graph/groups@v1.0' = {
    displayName: '${projectName}${suffix1}'
    uniqueName: '${projectName}${suffix1}'
    description: 'Developers in the ${projectName} project'
    mailEnabled: false
    mailNickname: '${projectName}DeveloperGroup'
    securityEnabled: true
  
}

resource programReaderGroup 'Microsoft.Graph/groups@v1.0' = {
  displayName: '${projectName}${suffix2}'
  uniqueName: '${projectName}${suffix2}'
  description: 'Developers in the ${projectName} project'
  mailEnabled: false
  mailNickname: '${projectName}DeveloperGroup'
  securityEnabled: true

}
