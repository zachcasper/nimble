extension radius
extension radiusResources

resource nimble 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'nimble'
  properties: {
    compute: {
      kind: 'kubernetes'   // Required. The kind of container runtime to use
      namespace: 'nimble' // Required. The Kubernetes namespace in which to render application resources
    }
    recipes: {
      'Radius.Resources/webService': {
        default: {
          templateKind: 'bicep'
          templatePath: 'ghcr.io/zachcasper/recipes/webservice:latest'
        }
      }
      'Radius.Resources/postgreSQL': {
        default: {
          templateKind: 'terraform'
          templatePath: 'git::https://github.com/zachcasper/nimble.git//recipes/postgresql'
        }
      'Radius.Resources/openAI': {
        default: {
          templateKind: 'terraform'
          templatePath: 'git::https://github.com/zachcasper/nimble.git//recipes/azure/openAI'
          parameters: {
            resource_group_name: 'reabdul'
            location: 'eastus'
          }
        }
      }
    }
  }
}

// Shared resource for all applications representing an external service
resource jira 'Radius.Resources/externalService@2023-10-01-preview' = {
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
