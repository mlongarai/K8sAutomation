#!/bin/bash
export PATH="$PATH:/usr/local/bin/"
source ~/.bash_profile

function check_azure_login {
	if [ $(az account show | wc -l) -eq 0 ]; then
		echo "Error";
	else
		echo "Success";
	fi;
}

if [ "$(check_azure_login)" == "Error" ]; then
      echo "Error";
	exit 1
   else	
	#Count Resources
      az group list | grep -rcZ "name" | awk -F'\0' '{s+=$NF}END{print s}'
	
	#Count Clusters
	az aks list | grep -rcZ "Microsoft.ContainerService/ManagedClusters" | awk -F'\0' '{s+=$NF}END{print s}'
	
	#Count Nodes
	az graph query -q "where type =~ 'Microsoft.Compute/virtualMachines'" | grep -rcZ "microsoft-aks" | awk -F'\0' '{s+=$NF}END{print s}'
	
	#Count Pods
	kubectl describe pods | grep -rcZ "Namespace" |awk -F'\0' '{s+=$NF}END{print s}'
fi