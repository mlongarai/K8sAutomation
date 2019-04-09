#!/bin/bash
export PATH="$PATH:/usr/local/bin/"
source ~/.bash_profile

helpFunction()
{
   echo ""
   echo "Usage: $0 -a MyResourceGroup -b MyClusterK8s -c MyAppName -d MyServiceName -e MyDNSsuffix -f LocationProvisioned -g MyPath"
   echo -e "\t-a Name of new Resource Group of Azure"
   echo -e "\t-b Name of new Cluster K8s"
   echo -e "\t-c Name of new App"
   echo -e "\t-d Name of new Service"
   echo -e "\t-e Name of new DNS suffix"
   echo -e "\t-f Name of location provisioned"
   echo -e "\t-g Path of file(s)"
   exit 1 # Exit script after printing help
}

while getopts "a:b:c:d:e:f:g:" opt
do
   case "$opt" in
      a ) resource_group="$OPTARG" ;;
      b ) aks_name="$OPTARG" ;;
      c ) app_name="$OPTARG" ;;
      d ) aks_service="$OPTARG" ;;
      e ) dns_name_suffix="$OPTARG" ;;
      f ) aks_location="$OPTARG" ;;
      g ) aks_files="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$resource_group" ] || [ -z "$aks_name" ] || [ -z "$app_name" ] || [ -z "$aks_service" ] || [ -z "$dns_name_suffix" ] || [ -z "$aks_location" ] || [ -z "$aks_files" ]
then
   echo "Some or all of the parameters are empty";
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
      echo -e "Logged on Azure!"
fi
echo "-----------------------------------"

temp_companion_rg="MC_${resource_group}_${aks_name}_${aks_location}"
companion_rg=${temp_companion_rg// /}

#kubeconfig="$(mktemp)"
echo "Fetch AKS credentials to $aks_name..."
nohup az aks get-credentials -g $resource_group -n $aks_name &>/dev/null &
sleep 10
echo "-----------------------------------"
echo -n "Checking Kubernetes Cluster for $aks_name..."
if [[ "$(kubectl get svc --namespace default kubernetes -o jsonpath='{.metadata.labels.provider}')" == "kubernetes" ]]; then
    echo "Setting up Dashboard K8s for $aks_name..."
    nohup kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard &>/dev/null &
fi
echo "-----------------------------------"
echo "Checking Manifest files..."
SAVEIFS="$IFS"
IFS=$(echo -en "\n\b")
eval "arr=($aks_files)"
for i in "${arr[@]}"; do
    #echo "Apply $i"
    kubectl apply -f "$i"
done
IFS="$SAVEIFS"
echo "-----------------------------------"
function assign_dns {
    aks_service="$1"
    dns_name="${2// /}"
    IP=
    while true; do
        echo -n "Waiting external IP for $aks_service..."
        IP="$(kubectl get service "$aks_service" | tail -n +2 | awk '{print $4}' | grep -v '<')"
        if [[ "$?" == 0 && -n "$IP" ]]; then
            echo -n "Service $aks_service public IP: $IP"
            break
        fi
        sleep 120 # Aprox. 2 mim to create Service IP
    done

    public_ip="$(az network public-ip list -g "$companion_rg" --query "[?ipAddress==\`$IP\`] | [0].id" -o tsv)"
    if [[ -z "$public_ip" ]]; then
        echo -n "Cannot find public IP resource ID for '$aks_service' in companion resource group '$companion_rg'" >&2
        exit 1
    fi
    
    echo -n "Assign DNS name '$dns_name' for '$aks_service'... Wait..."
    echo " "
    az network public-ip update --dns-name "$dns_name" --ids "$public_ip" >/dev/null
    [[ $? != 0 ]] && exit 1
    echo -n "Assigned!"
}
temp_dns_assign="$app_name-$dns_name_suffix"
thisdns="${temp_dns_assign// /}"
assign_dns $app_name "$thisdns"
rm -f "$kubeconfig"
echo "-----------------------------------"
urlapi="http://$temp_dns_assign.eastus.cloudapp.azure.com"
echo "Copy URL page AND access WITH your PORT exposed"
echo " '${urlapi// /}' "
echo " "
echo " "
echo " "
sleep 10
echo "Finished!"