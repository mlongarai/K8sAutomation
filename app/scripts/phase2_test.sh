#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

helpFunction()
{
   echo ""
   echo "Usage: $0 -a MyResourceGroup -b MyClusterK8s -c MyAppName -d MyServiceName -e MyDNSsuffix -f LocationProvisioned"
   echo -e "\t-a Name of new Resource Group of Azure"
   echo -e "\t-b Name of new Cluster K8s"
   echo -e "\t-c Name of new App"
   echo -e "\t-d Name of new Service"
   echo -e "\t-e Name of new DNS suffix"
   echo -e "\t-f Name of location provisioned"
   exit 1 # Exit script after printing help
}

while getopts "a:b:c:d:e:f:" opt
do
   case "$opt" in
      a ) resource_group="$OPTARG" ;;
      b ) aks_name="$OPTARG" ;;
      c ) app_name="$OPTARG" ;;
      d ) aks_service="$OPTARG" ;;
      e ) dns_name_suffix="$OPTARG" ;;
      f ) aks_location="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$resource_group" ] || [ -z "$aks_name" ] || [ -z "$app_name" ] || [ -z "$aks_service" ] || [ -z "$dns_name_suffix" ] || [ -z "$aks_location" ]
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

kubeconfig="$(mktemp)"

echo "Fetch AKS credentials to $kubeconfig"
az aks get-credentials -g "$resource_group" -n "$aks_name" --admin --file "$kubeconfig"

echo "      Checking Kubernetes Cluster for $aks_name..."
if [[ "$(kubectl get svc --namespace default kubernetes -o jsonpath='{.metadata.labels.provider}')" == "kubernetes" ]]; then
    echo "      Setting up Dashboard K8s for $aks_name"
    /usr/local/bin/kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard
fi

SAVEIFS="$IFS"
IFS=$(echo -en "\n\b")
for config in "$DIR"*.json; do
    echo "Apply $config"
    /usr/local/bin/kubectl apply -f "$config" --kubeconfig "$kubeconfig"
done
IFS="$SAVEIFS"

SAVEIFS="$IFS"
IFS=$(echo -en "\n\b")
for config in "$DIR"*.yaml; do
    echo "Apply $config"
    /usr/local/bin/kubectl apply -f "$config" --kubeconfig "$kubeconfig"
done
IFS="$SAVEIFS"

rm -f "$kubeconfig"

/usr/local/bin/kubectl get all

echo "Browsing Dashboard Kubernetes..."
az aks browse --resource-group $resource_group --name $aks_name