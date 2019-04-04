#!/bin/bash

resource_group=k8s-automation
registry_name=k8sautomation
location=eastus
aks_name=k8s-automation
SERVICE_PRINCIPAL_NAME=acr-service-principal

# Get the id of the service principal configured for AKS
CLIENT_ID=$(az aks show --resource-group $resource_group --name $aks_name --query "servicePrincipalProfile.clientId" --output tsv)

# Get the ACR registry resource id
ACR_ID=$(az acr show --name $registry_name --resource-group $resource_group --query "id" --output tsv)

# Create role assignment
az role assignment create --assignee $CLIENT_ID --role acrpull --scope $ACR_ID

# Populate the ACR login server and resource id.
ACR_LOGIN_SERVER=$(az acr show --name $registry_name --query loginServer --output tsv)
ACR_REGISTRY_ID=$(az acr show --name $registry_name --query id --output tsv)

# Create acrpull role assignment with a scope of the ACR resource.
SP_PASSWD=$(az ad sp create-for-rbac --name http://$SERVICE_PRINCIPAL_NAME --role acrpull --scopes $ACR_REGISTRY_ID --query password --output tsv)

# Get the service principal client id.
CLIENT_ID=$(az ad sp show --id http://$SERVICE_PRINCIPAL_NAME --query appId --output tsv)

# Output used when creating Kubernetes secret.
echo "Service principal ID: $CLIENT_ID"
echo "Service principal password: $SP_PASSWD"