# K8sAutomation for Azure Kubernetes Service (AKS)

[![k8sautomation.gif](https://s2.gifyu.com/images/k8sautomation.gif)](https://gifyu.com/image/3rp1)

## Overview

This is a desktop app was built with [Electron](http://electronjs.org). This app works only macOS operating system.

Use this app to provision and deploy a kubernetes cluster and and build your microservice architecture with your help.

This project proposes to build a set of routines to accelerate the creation of an ecosystem in the flow of software development, enabling the automation of the construction of an initial environment for approval and testing of the project, seeking to facilitate the configuration, management, and monitoring of the environments through Kubernetes, container orchestrator, provides stability, scalability and centralized maintenance.

### Requirements

* Open the terminal and write:
Login Azure CLI

   ```sh
   az login
   ```

* Select the demos subscription

   ```sh
   az account set --subscription "<subscription-id>"
   ```

## Getting Started

### Creating a new AKS infrastructure

### Download and Run

* Get latest Release: [Latest](https://github.com/mlongarai/K8sAutomation/releases/latest)

OR

* Do yourself: 

   ```Github
   git clone https://github.com/mlongarai/K8sAutomation.git
   cd K8sAutomation
   npm install
   npm start
   ```

### Provisioning

![Provisioning](https://i.imgur.com/6pwdNCD.png)

* Fill out:

   * Name of new Resource Group of Azure
   * Name of new Azure Container Registry
   * Name of new Cluster K8s
   * Number of Cluster Nodes
   * Name of Location
   * Name of VM Size 

And press Apply.

* Console:

You can see all information of provisioning steps on console.

### Deploying

![Deploying](https://i.imgur.com/cpqtyI8.png)

For this step you need to use some example like [api-mongodb-jenkins-example](https://github.com/mlongarai/) for deploy pods, services, deployments, etc.

* Fill out:

   * Name of new Resource Group of Azure
   * Name of new Cluster K8s
   * Name of new App
   * Name of new Service
   * Name of new DNS suffix
   * Name of location provisioned

And press Apply.

* Console:

You can see all information of deploying steps on console.

### Monitoring your Infrastructure

* [Azure Portal](http://portal.azure.com/)
* [Kubernetes Dashboard](https://github.com/kubernetes/dashboard)

### Examples of K8s architecture scenarios

* [api-mongodb-jenkins-example](https://github.com/mlongarai/): API for Documentation using Node.js + MongoDB + Jenkins for CI/CD


### Deleting the AKS infrastructure (and all associated resources)

* Open the terminal and write:
   ```vim
   az group delete -n MyResourceGroup --no-wait
   ```

## Credits

* Original idea of base code shell script by [Azure Voting App](https://github.com/Azure-Samples/azure-voting-app-redis).
* Original idea of base code electron app by [Electron Run Shell Example](https://github.com/martinjackson/electron-run-shell-example).

## Contributors

A special thanks to my friends who helped me heal complex architecture and software development issues in this projec.

* @[eduth](https://github.com/eduth)


<p align="center">
  <br>
  <br>
  <b>“Thank you to all who have contributed in this great work”</b><br>
  <br><br>
</p>