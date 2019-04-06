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

/usr/local/bin/kubectl get nodes