extension radius
extension cableco

resource nimble 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'nimble'
  properties: {
    compute: {
      kind: 'kubernetes'   // Required. The kind of container runtime to use
      namespace: 'nimble2' // Required. The Kubernetes namespace in which to render application resources
    }
    recipes: {
      'CableCo.Radius/webService': {
        default: {
          templateKind: 'bicep'
          templatePath: 'ghcr.io/zachcasper/recipes/webservice:latest'
        }
      }
      'CableCo.Radius/postgreSQL': {
        default: {
          templateKind: 'terraform'
          templatePath: 'git::https://github.com/zachcasper/nimble.git//recipes/postgresql'
        }
      }
    }
  }
}

resource jira 'CableCo.Radius/externalService@2023-10-01-preview' = {
  name: 'jira'
  properties:{
    connectionString: 'https://api.atlassian.com/ex/jira/<cloudId>/rest/api/3/<resource-name>'
    credentials: {
      type: 'apiKey'
      apiKey: 'your-api-key'
    }
    environment: nimble.id 
  }
}
