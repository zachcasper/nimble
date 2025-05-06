extension radius
extension cableco

param environment string

resource jira 'CableCo.Radius/externalService@2023-10-01-preview' = {
  name: 'jira'
  properties:{
    connectionString: 'https://api.atlassian.com/ex/jira/<cloudId>/rest/api/3/<resource-name>'
    credentials: {
      type: 'apiKey'
      apiKey: 'your-api-key'
    }
    environment: environment 
  }
}
