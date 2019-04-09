#!/bin/bash
export PATH="$PATH:/usr/local/bin/"
source ~/.bash_profile
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
helpFunction()
{
   echo -n ""
   echo -n "Usage: $0 -a MyResourceGroup -b MyContainerRegistry -c MyClusterK8s -d NumberNodes -e Location -f VMSize"
   echo -n "\t-a Name of new Resource Group of Azure"
   echo -n "\t-b Name of new Azure Container Registry"
   echo -n "\t-c Name of new Cluster K8s"
   echo -n "\t-d Number of Cluster Nodes"
   echo -n "\t-e Name of Location"
   echo -n "\t-f Name of VM Size"
   exit 1 # Exit script after printing help
}
while getopts "a:b:c:d:e:f:" opt
do
   case "$opt" in
      a ) resource_group="$OPTARG" ;;
      b ) registry_name="$OPTARG" ;;
      c ) aks_name="$OPTARG" ;;
      d ) nodes="$OPTARG" ;;
      e ) aks_location="$OPTARG" ;;
      f ) vmsize="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done
# Print helpFunction in case parameters are empty
if [ -z "$resource_group" ] || [ -z "$registry_name" ] || [ -z "$aks_name" ] || [ -z "$nodes" ] || [ -z "$aks_location" ] || [ -z "$vmsize" ]
then
   echo -n "Some or all of the parameters are empty";
   helpFunction
fi

echo -n "Checking Azure CLI login..."
function check_azure_login {
	if [ $(az account show | wc -l) -eq 0 ]; then
      echo "false";
	else
		echo "true";
	fi;
}
if [ "$(check_azure_login)" == "false" ]; then
      echo "Enter your login Azure"
      az login;
   else
      echo "Logged on Azure!"
fi
echo "-----------------------------------"
echo -n "Checking resource group $resource_group..."
if [[ "$(az group exists --name $resource_group)" == "false" ]]; then
      echo -n "Creating resource group $resource_group..."
      az group create -n $resource_group -l $aks_location || exit 1
      sleep 10
    else
      echo "$resource_group already exist."
fi
echo "-----------------------------------"
echo -n "Checking Azure Container Registry for $registry_name..."
if [[ "$(az acr show --name $registry_name --resource-group $resource_group --query 'provisioningState' --output tsv)" == "Succeeded" ]]; then
      echo "$registry_name already exist."
   else
      echo -n "Creating Azure Container Registry $registry_name..."
      az acr create --resource-group $resource_group --name $registry_name --sku Basic  || exit 1
      sleep 10
fi
echo -n "-----------------------------------"
echo -n "Checking Azure Kubernetes Service for $aks_name..."
if [[ "$(az aks show -g $resource_group -n $aks_name --query 'provisioningState' --output tsv)" == "Succeeded" ]]; then
    echo "$aks_name already exist."
    else
    echo -n "Creating AKS $aks_name..."
    az aks create -g $resource_group -n $aks_name --node-count $nodes --node-vm-size $vmsize  || exit 1
    echo "Setting up Kubernetes Nodes for $aks_name... could take more than 10 min to complete."
    echo -n "Follow the end of creation on Azure Portal."
    sleep 60
fi
echo -n "-----------------------------------"
kubeconfig="$(mktemp)"
echo -n "Fetch AKS credentials to $aks_name..."
az aks get-credentials -g $resource_group -n $aks_name --admin --file "$kubeconfig"

echo "Finished!"