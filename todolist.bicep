extension radius
extension cableco

param environment string

resource todolist 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'todolist'
  properties: {
    environment: environment
  }
}

resource frontend 'CableCo.Radius/webService@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: todolist.id
    environment: environment
    ingress: true
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        http: {
          containerPort: 3000
        }
      }
      env: {
        CONNECTION_POSTGRESQL_HOST: {
          value: db.properties.status.binding.host
        }
        CONNECTION_POSTGRESQL_PORT: {
          value: string(db.properties.status.binding.port)
        }
        CONNECTION_POSTGRESQL_USERNAME: {
          value: db.properties.status.binding.username
        }
        CONNECTION_POSTGRESQL_DATABASE: {
          value: db.properties.database
        }
        CONNECTION_POSTGRESQL_PASSWORD: {
          value: db.properties.status.binding.password
        } 
        CONNECTION_JIRA_HOST: {
          value: jira.properties.connectionString
        }
        CONNECTION_JIRA_API_KEY: {
          value: jira.properties.credentials.apiKey
        }
      }
    }
  }
}

resource db 'CableCo.Radius/postgreSQL@2023-10-01-preview' = {
  name: 'db'
  properties: {
    application: todolist.id
    environment: environment
    database: 'todolist'
  }
}

resource jira 'CableCo.Radius/externalService@2023-10-01-preview' existing =  {
  name: 'jira'
}
