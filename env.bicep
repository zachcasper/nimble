extension radius
extension radiusResources

resource nimble 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'nimble-dev'
  properties: {
    compute: {
      kind: 'kubernetes'
      namespace: 'nimble-dev'
    }
    providers: {
      azure: {
        // Update subscription and resource group
        scope: '/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>'
      }
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
          templatePath: 'git::https://github.com/zachcasper/nimble.git//recipes/kubernetes/postgresql'
        }
      }
      'Radius.Resources/openAI': {
        default: {
          templateKind: 'terraform'
          templatePath: 'git::https://github.com/zachcasper/nimble.git//recipes/azure/openAI'
          parameters: {
            // Update resource group name
            resource_group_name: 'nimble-dev'
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
