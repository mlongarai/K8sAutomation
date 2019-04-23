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
	#Count by location
	az graph query -q "where type =~ 'Microsoft.Compute/virtualMachines' | summarize count() by location"
fi