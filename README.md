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

| Secret Name | Description | Value 
| ----------- | ------------|
| AAD_ADMIN_GROUP_ID | When Azure AD Admin Group for Kubernetes | The object ID of the Azure AD Group


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




