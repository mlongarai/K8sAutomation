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
	#echo "[{\"count_\": 2,\"location\": \"centralus\"},{\"count_\": 5,\"location\": \"eastus\"},{\"count_\": 5,\"location\": \"eastus2\"}]"
	#echo "[{\"count_\": 2,\"location\": \"australiaeast\"},{\"count_\": 5,\"location\": \"australiasoutheast\"},{\"count_\": 2,\"location\": \"canadacentral\"},{\"count_\": 2,\"location\": \"canadaeast\"},{\"count_\": 2,\"location\": \"centralindia\"},{\"count_\": 2,\"location\": \"centralus\"},{\"count_\": 2,\"location\": \"eastasia\"},{\"count_\": 2,\"location\": \"eastus\"},{\"count_\": 2,\"location\": \"eastus2\"},{\"count_\": 2,\"location\": \"francecentral\"},{\"count_\": 2,\"location\": \"japaneast\"},{\"count_\": 2,\"location\": \"koreacentral\"},{\"count_\": 2,\"location\": \"koreasouth\"},{\"count_\": 2,\"location\": \"northeurope\"},{\"count_\": 2,\"location\": \"southeastasia\"},{\"count_\": 2,\"location\": \"southcentralus\"},{\"count_\": 2,\"location\": \"southindia\"},{\"count_\": 2,\"location\": \"uksouth\"},{\"count_\": 2,\"location\": \"ukwest\"},{\"count_\": 2,\"location\": \"westeurope\"},{\"count_\": 2,\"location\": \"westus\"},{\"count_\": 2,\"location\": \"westus2\"}]"
	#Count by location
	az graph query -q "where type =~ 'Microsoft.Compute/virtualMachines' | summarize count() by location"
fi