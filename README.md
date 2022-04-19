# DevSecOps for Containers

**<span style="font-size:larger;">WORK IN PROGRESS</span>**

## Introduction

This Github repository provides an opinionated implementation of a DevSecOps pipeline for your container workloads running in Azure Kubernetes Services (AKS).

The sample application used in this git repository is the [EShop on Dapr app](https://github.com/dotnet-architecture/eShopOnDapr).

This repository uses GitHub Actions but you could use any CI/CD tooling to run your DevSecOps pipeline.

The sample show an implementation of DevSecOps for container end to end in a CI/CD pipeline.

# How to install the demo

## Fork the repository

The first thing to do is to fork the repository.

## Create a Service Principal to run the GitHub Actions

If it's not already done you will need to create a service principal to create your resources in Azure.

To do so follow the instruction [here](https://github.com/marketplace/actions/azure-login#configure-a-service-principal-with-a-secret).

Copy/Paste the output result, you will need to create it for a GitHub Secret.  **The scope** of the service principal for this demo should be at subscription level.

The contributor role won't be enough to create the cluster.  See the section Create Azure Resources for more details.  Here you can give Contributor to the service principal and create a custom role for the AAD permission.  If you want lower than Contributor you will need to assign the proper rights to the Service Principal.

## Create an account for Snyk

One of the tool used in this demo is Snyk, Snyk is used to scan the code of the application, the dependency chain, the bicep files and finally the Kubernetes manifest file.

Go to Snyk [website](https://snyk.io/) and create a free account.

Select the eShopDaprDevOps repository only (you can choose more if you want).

<img alt="Alt text" src="https://raw.githubusercontent.com/appdevgbb/eShopDaprDevOps/main/images/snykrepo.png">

Click the Import and scan button.

Now you will need to get your Snyk Token, it's needed for a GitHub secrets.

To find it follow those [instructions](https://github.com/marketplace/actions/snyk#getting-your-snyk-token).

## Create a GitHub Personal Token

In the GitHub Action one of the step will write secrets, depending if your repository is public or private the right will be different.

Follow the instruction [here](https://github.com/gliech/create-github-secret-action#pa_token) to create your GitHub Personal  access token with the right permission.  Write it down, you will need it when creating the GitHub Secrets.

## Create an Azure Active Directory Group for Kubernetes

The kubernetes cluster is created with Azure Active Directory integration.  This mean you will need to create a group in Active Directory, follow this [instruction](https://docs.microsoft.com/en-us/azure/aks/managed-aad#before-you-begin) to create the Azure AD Group.  Be sure to add yourself to the group and take note of the 
**object ID** returned after creating the AAD Group.

## Create the GitHub Secrets

Now before executing the GitHub Action you will need to create some GitHub Secrets.

| Secret Name | Description 
| ----------- | ------------
| AAD_ADMIN_GROUP_ID | The object ID of the Azure AD Admin Group created before
| ADMIN_USERNAME | Username to login to the Github Self Runner VM
| ADMIN_PASSWORD | Password to login to the GitHub Self Runner VM
| AZURE_CREDENTIALS | The service principal created before
| PA_TOKEN | The personnal GitHub Token created before
| SNYK_TOKEN | The SNYK token from your Snyk Account
| SUBSCRIPTION_ID | The subscription ID where the Azure Resources will be created

## Create Azure Resources

Now is time to create all the resources in Azure, go to the Actions tab in GitHub and run the **Create Azure Resources** action.

If the GitHub Action fail with the following error:

<img alt="Alt text" src="https://raw.githubusercontent.com/appdevgbb/eShopDaprDevOps/main/images/error.png">

This mean your service principal doesn't have enough write. You can give it the **Owner** role or create a custom role with **Microsoft.Authorization/roleAssignments/write**.

**It's recommended** to create custom role to have the less privilege possible.

The custom role will look something like this.

<img alt="Alt text" src="https://raw.githubusercontent.com/appdevgbb/eShopDaprDevOps/main/images/customrole.png">

## Create more GitHub Secrets.

Now you need to add two more GitHub secrets.

Go to the resource group **rg-aks-devsecops** in the Azure Portal.  You will see your Container registry, click on it and go to **Access keys** in the left blade menu.

From there copy the **username** and **password**

You will create those two GitHub Secrets.

| Secret Name | Description 
| ----------- | ------------
| REGISTRY_USERNAME | The username of the Azure Container Registry
| REGISTRY_PASSWORD | The password of the Azure Container Registry

## Configure the GitHub Self-Runner

Because the Kubernetes API and the Azure Container Registry are using private endpoint we need to use two GitHub Self-Runner to deploy and create our docker image.

Now is time to configure the two GitHub Self-Runner.  In the resource group you will see two Linux Virtual Machine

<img alt="Alt text" src="https://raw.githubusercontent.com/appdevgbb/eShopDaprDevOps/main/images/runner.png">

Login to the first virtual machine (runner-0).

Run the following commands

```
sudo usermod -aG docker $USER
newgrp docker
sudo chown root:docker /var/run/docker.sock
```

Now [install](https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners) the GitHub Self-Runner agent

Repeat the same process for the Virtual Machine called runner-1

## Install the core services and dapr in AKS

Now is time to install all the storage services and Dapr components in AKS.  To do so go to the **Actions tab** in the GitHub repository and run the **Configure Kubernetes** action.

## Deploy payment api

Right now, only payment api is possible to be deployed in Kubernetes.  All the other Github Action will only created the docker image and push it into an Azure Container Registry.

# Toolchain

We used a variety of tools from various organizations in this project including Snyk, Aqua Security, Microsoft Defender and more.

| DevSec Process          | DevSec Tool          |
|------------------|---------------|
| Static code analysis and code quality scan | Snyk Code, ESLint, BinSkim | 
| Credential scan | CredScan (Microsoft Security DevOps)| 
| OSS Dependency scan | Snyk Open Source |
| Container scan (before pushing to registry) | Trivy, Dockle | 
| Container scan (in registry) | Microsoft Defender for Containers | 
| Infrastructure scan | Snyk IAC, Terrascan, ARM Template Analyzer |
| Container scan (in cluster)| Microsoft Defender for Containers |

![flow](./diagram/flow.png)




