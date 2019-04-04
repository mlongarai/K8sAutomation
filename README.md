# K8sAutomation for Azure Kubernetes Service (AKS)

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

Select the demos subscription

   ```sh
   az account set --subscription "<subscription-id>"
   ```

## Getting Started

### Deploying a new AKS infrastructure

### Download

Latest Release: 

or

   ```Github
   git clone https://github.com/mlongarai/K8Automation.git
   cd K8sAutomation
   npm install
   npm start
   ```

### Run

```Github
   git clone https://github.com/mlongarai/K8sAutomation.git
   cd K8sAutomation
   npm install
   npm start
   ```

### Examples of architecture scenarios

* [api-mongodb-jenkins-example](https://github.com/mlongarai/): API for Documentation using Node.js + MongoDB + Jenkins for CI/CD

### Deleting the AKS infrastructure (and all associated resources)

* Open the terminal and write:
   ```vim
   az group delete -n MyResourceGroup --no-wait
   ```

### Credits

Original idea of base code by [Azure Voting App] (https://github.com/Azure-Samples/azure-voting-app-redis).

### Contributors

a special thanks to my friends who helped me heal complex architecture and software development issues in this project.

* [eduth] (https://github.com/eduth)


## “Thank you to all who have contributed in this great work”
