# Nimble Example
This repository is an example Radius setup for an application with four Radius resource types:
 

In the future, we will implement a `Radius.Resources/openAI` which deploys a model using Azure OpenAI.

## Overview of sample

This sample has the following components:

#### 1. Three resource type definitions defined in YAML in types.yaml: 

* `Radius.Resources/webService` – A resource type which deploys a containerized service. The resource type has a container property based on the Applications.Core/containers resource type. This makes it trivial to pass the container property to the Applications.Core/containers resource in the recipe. The ingress property is used by the developer to specify whether a Applications.Core/gateways should also be created. 

* `Radius.Resources/postgreSQL` – A PostgreSQL database. The only property is setting the database name.

* `Radius.Resources/externalService` – This resource type is used to represent a service which is not mananaged by Radius. Since there is no recipe and no actual resource deployed, it functions similar to a Kubernetes, ConfigMap.

* `Radius.Resources/openAI` – A resource type which deploys Azure OpenAI services. The only property is setting the capacity for the API.

#### 2. A recipe implemented in Bicep for the webServices resource type. 

#### 3. A recipe implemented in Terraform for the postgreSQL resource type.

#### 4. A recipe implemented in Bicep and Terraform for the openAI resource type.

#### 5. An environment specification which includes the recipes and an externalService resource representing the cloud service Jira.

## Setup
### Create resource types

```bash
rad resource-type create webService -f types.yaml
rad resource-type create postgreSQL -f types.yaml
rad resource-type create externalService -f types.yaml
rad resource-type create openAI -f types.yaml
```
Note that resource type names are camelCase and case sensitive.

### Create Bicep extension
```
rad bicep publish-extension -f types.yaml --target radiusResources.tgz
```

### Verify bicepconfig.json
Open bicepconfig.json and verify the `radiusResources` extension is referencing the correct archive file. Bicep extensions in the same working directory can be the filename only. If you move the bicepconfig.json file or the extension archive, you must specify the full file path (not a relative path).

### Publish recipes
This sample demonstrates recipes using both Terraform configurations and Bicep templates. Using Bicep templates for recipes has the advantage of being able to use Radius resource types in the recipe. In this sample, the recipe for the webService resource type uses the containers and gateways resource types. Terraform can only define resources from existing Terraform providers. We do not have a Radius resource provider for Terraform yet so it is not possible to use the containers or gateways resources in Terraform.

When you register a recipe with Radius, you are only creating a pointer to a Terraform configurations or Bicep templates. Terraform configurations are stored in a git repository. Bicep templates are stored in a container registry. In this sample we are ignoring authentication to the Git repository and container registry. If you need to setup authentication see [this for Terraform](https://docs.radapp.io/guides/recipes/terraform/howto-private-registry/) and [this for Bicep](https://docs.radapp.io/guides/recipes/howto-private-bicep-registry/).

**webService**
Publish the webServices Bicep recipe to a container registry:
```
rad bicep publish --file recipes/webservice.bicep \
  --target br:ghcr.io/zachcasper/recipes/webservice:latest
```
`br` stands for Bicep registry. The remainder of the string is a standard container image name.

**postgreSQL**
Push the Terraform configuration to a Git repository. You must use the standard Terraform naming scheme. In this case, the main.tf file is in the postgreSQL directory. 

**openAI**
Push the Terraform configuration to a Git repository. You must use the standard Terraform naming scheme. In this case, the main.tf file is in the openAI directory and requires parameters resource group and location to be passed to the recipe while registering.

### Create environment with recipes registered and Jira externalService resource
```
rad deploy env.bicep
```
Confirm the environment was created. You should see this output.
```
$ rad environment list
RESOURCE  TYPE                            GROUP     STATE
nimble    Applications.Core/environments  default   Succeeded
```
Confirm the Jira externalService resource was created.
```
$ rad resource list Radius.Resources/externalService
RESOURCE  TYPE                            GROUP     STATE
jira      Radius.Resources/externalService  default   Succeeded
```

## Deploy the todolist application
This sample uses the todolist demo application from Radius. Deploy the application
```
rad deploy todolist.bicep
```
Get the URL for the gateway:
```
rad resource show Applications.Core/gateways gateway -o json | grep url
```
