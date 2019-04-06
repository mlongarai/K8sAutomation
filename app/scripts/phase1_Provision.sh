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

#echo "Checking Azure CLI login..."
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
    echo "Logged on Azure!"
fi

echo "Checking resource group $resource_group..."
if [[ "$(az group exists --name $resource_group)" == "false" ]]; then
    echo "Creating resource group $resource_group..."
    az group create -n "$resource_group" -l "$aks_location"
    echo " $resource_group alredy exist."
fi

echo "Checking Azure Container Registry for $registry_name..."
if [[ "$(az acr show --name $registry_name --resource-group $resource_group --query 'provisioningState' --output tsv)" == "Succeeded" ]]; then
    echo " $registry_name alredy exist."
   else
    echo "Creating Azure Container Registry $registry_name..."
    az acr create --resource-group $resource_group --name $registry_name --sku Basic
fi

echo "Checking Azure Kubernetes Service for $aks_name..."


if [[ "$(az aks show -g $resource_group -n $aks_name --query 'provisioningState' --output tsv)" == "Succeeded" ]]; then
    echo " $aks_name alredy exist."
    else
    echo "Creating AKS $aks_name..."
    az aks create -g "$resource_group" -n $aks_name --node-count $nodes --node-vm-size $vmsize
    echo "Setting up Kubernetes Nodes for $aks_name... could take more than 10 min to complete."
    echo "Follow the end of creation on Azure Portal."
    sleep 60
fi

kubeconfig="$(mktemp)"

echo "Fetch AKS credentials to $kubeconfig..."
az aks get-credentials -g $resource_group -n $aks_name --admin --file "$kubeconfig"

echo " "
echo "------------------"
echo " Your RG is: $resource_group"
echo " Your ACR is: $registry_name"
echo " Your AKS is: $aks_name"
echo " "
echo "finished!"