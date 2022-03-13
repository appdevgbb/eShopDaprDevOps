# DevSecOps for Containers

**<span style="font-size:larger;">WORK IN PROGRESS</span>**

## Introduction

This Github repository provides an opinionated implementation of a DevSecOps pipeline for your container workloads running in Azure Kubernetes Services (AKS).

The sample application used in this git repository is the [EShop on Dapr app](https://github.com/dotnet-architecture/eShopOnDapr).

This repository uses GitHub Actions but you could use any CI/CD tooling to run your DevSecOps pipeline.

## Toolchain

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




