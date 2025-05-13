extension radius

extension radiusResources

param environment string

resource todolist 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'todolist'
  properties: {
    environment: environment
  }
}

resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: todolist.id
    environment: environment
    container: {
      // This image has the openAI intergration
      image: 'ghcr.io/reshrahim/demoai:latest'
      ports: {
        http: {
          containerPort: 3000
        }
      }
      env: {
        CONNECTION_POSTGRESQL_HOST: {
          value: db.properties.host
        }
        CONNECTION_POSTGRESQL_PORT: {
          value: string(db.properties.port)
        }
        CONNECTION_POSTGRESQL_USERNAME: {
          value: db.properties.username
        }
        CONNECTION_POSTGRESQL_DATABASE: {
          value: db.properties.database
        }
        CONNECTION_POSTGRESQL_PASSWORD: {
          value: db.properties.password
        } 
        CONNECTION_JIRA_HOST: {
          value: jira.properties.connectionString
        }
        CONNECTION_JIRA_API_KEY: {
          value: jira.properties.credentials.apiKey
        }
        CONNECTION_AI_ENDPOINT: {
          value: openai.properties.endpoint
        }
        CONNECTION_AI_DEPLOYMENT: {
          value: openai.properties.deployment
        }
        CONNECTION_AI_APIKEY:{
          value: openai.properties.apiKey
        }
        CONNECTION_AI_APIVERSION:{
          value: openai.properties.apiVersion
        }
      }
    }
  }
}

resource db 'Radius.Resources/postgreSQL@2023-10-01-preview' = {
  name: 'db'
  properties: {
    application: todolist.id
    environment: environment
    size: 'S'
  }
}

resource openai 'Radius.Resources/openAI@2023-10-01-preview' = {
  name: 'openai'
  properties: {
    application: todolist.id
    environment: environment
    capacity: 'S'
  }
}

resource jira 'Radius.Resources/externalService@2023-10-01-preview' existing =  {
  name: 'jira'
}
