#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

helpFunction()
{
   echo ""
   echo "Usage: $0 -a MyResourceGroup -b MyContainerRegistry -c MyClusterK8s -d NumberNodes -e Location -f VMSize"
   echo -e "\t-a Name of new Resource Group of Azure"
   echo -e "\t-b Name of new Azure Container Registry"
   echo -e "\t-c Name of new Cluster K8s"
   echo -e "\t-d Number of Cluster Nodes"
   echo -e "\t-e Name of Location"
   echo -e "\t-f Name of VM Size"
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
   echo "Some or all of the parameters are empty";
   helpFunction
fi

echo "Checking Azure CLI login..."
if [ ! az group list >/dev/null 2>&1 ];
      then
         echo "Enter you login Azure"
         az login
         if [ ! az group list >/dev/null 2>&1 ]; 
            then
            echo "Login Azure CLI required" >&2
            exit 1
         fi
    else
    echo "Logged on Azure. Finished!"
fi

companion_rg="MC_${resource_group}_${aks_name}_${aks_location}"

echo "      Checking Resource Group for $resource_group..."
if [[ "$(az group exists --name "$resource_group")" == "false" ]]; then
    echo "Creating Resource Group $resource_group"
    az group create -n "$resource_group" -l "$aks_location"
fi

echo "      Checking Azure Container Registry for $registry_name..."
if ! az acr repository show -n $resource_group --repository $resource_group >/dev/null 2>&1; then
    echo "Creating Azure Container Registry $aks_name"
    az acr create --resource-group $resource_group --name $registry_name --sku Basic
fi

echo "      Checking Azure Kubernetes Service for $aks_name..."
if ! az aks show -g "$resource_group" -n "$aks_name" >/dev/null 2>&1; then
    echo "Creating AKS $aks_name"
    az aks create -g "$resource_group" -n "$aks_name" --node-count "$nodes" --node-vm-size "$vmsize"
    echo "Setting up Kubernetes Nodes for $aks_name..."
    sleep 600 # Aprox. 10 mim to create AKS Cluster
fi

kubeconfig="$(mktemp)"

echo "Fetch AKS credentials to $kubeconfig"
az aks get-credentials -g "$resource_group" -n "$aks_name" --admin --file "$kubeconfig"

echo "Creating Azure Kubernetes Service finished!"