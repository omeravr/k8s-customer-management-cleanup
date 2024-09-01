# EKS Deployment with Terraform and GitHub Actions

This repository contains an automated workflow for deploying and managing an Amazon EKS cluster using Terraform. The infrastructure is provisioned with Terraform and managed using GitHub Actions running on a self-hosted runner.

## Prerequisites

Ensure the following tools are installed on your self-hosted runner:

- Terraform
- AWS CLI
- eksctl
- kubectl
- Helm
- Node.js

## Repository Structure

- **.github/workflows/deploy-eks.yml**: Workflow file for deploying the EKS cluster.
- **.github/workflows/destroy-eks.yml**: Workflow file for tearing down the EKS cluster.
- **terraform/eks-managed-node-group/**: Terraform configuration for the EKS cluster and managed node group.
- **app/test/nginx-deployment.yaml**: Kubernetes deployment for a simple NGINX application.
- **app/test/targetgroupbinding.yaml**: Target Group Binding for integrating NGINX with AWS Network Load Balancer.

## Workflow Overview

### Deployment Workflow (`deploy-eks.yml`)

This workflow automates the process of deploying an EKS cluster:

1. **Checkout Code**: Clones the repository.
2. **Setup Node.js**: Installs Node.js.
3. **Setup Terraform**: Installs Terraform.
4. **Create S3 Bucket**: Creates an S3 bucket for storing Terraform remote state.
5. **Terraform Init**: Initializes Terraform with the remote state configuration.
6. **Terraform Plan & Apply**: Provisions the EKS cluster and associated resources.
7. **Update Kubeconfig**: Updates kubeconfig to interact with the newly created EKS cluster.
8. **Install AWS Load Balancer Controller**: Deploys the AWS Load Balancer Controller using eksctl and Helm.
9. **Deploy NGINX Application**: Deploys a simple NGINX application to the EKS cluster.
10. **Create TargetGroupBinding**: Binds the NGINX service to an AWS Network Load Balancer.

### Teardown Workflow (`destroy-eks.yml`)

This workflow automates the process of tearing down the EKS cluster:

1. **Checkout Code**: Clones the repository.
2. **Setup Node.js**: Installs Node.js.
3. **Setup Terraform**: Installs Terraform.
4. **Delete IAM Service Account**: Deletes the IAM service account used by the AWS Load Balancer Controller.
5. **Terraform Init**: Initializes Terraform with the remote state configuration.
6. **Terraform Destroy**: Destroys the EKS cluster and associated resources.
7. **Delete S3 Bucket**: Deletes the S3 bucket used for storing Terraform remote state.

## Terraform Configuration

### `main.tf`

This file contains the Terraform configuration for provisioning the EKS cluster. It uses the `terraform-aws-modules/eks/aws` module to manage the cluster and its associated resources.

### `variables.tf`

This file defines the variables used in the Terraform configuration. Key variables include:

- `aws_region`: AWS region for the resources.
- `cluster_name`: Name of the EKS cluster.
- `cluster_version`: Kubernetes version (set to `1.30`).
- `vpc_id`: VPC ID where the EKS cluster is deployed.
- `subnet_ids`: List of subnet IDs for the EKS cluster.
- `instance_types`: Instance types for the EKS node group.
- `lb_subnet_ids`: Subnet IDs for the load balancer.
- `lb_internal`: Boolean indicating if the load balancer should be internal.

### `nginx-deployment.yaml`

Defines the deployment and service for an NGINX application that is exposed via a LoadBalancer service.

### `targetgroupbinding.yaml`

Defines the TargetGroupBinding resource, binding the NGINX service to the AWS Network Load Balancer.

## Secrets Configuration

The following secrets must be configured in your GitHub repository:

- `AWS_REGION`: The AWS region where the resources are deployed (e.g., `eu-central-1`).
- `CLUSTER_NAME`: The name of the EKS cluster.
- `CLUSTER_VERSION`: The Kubernetes version (e.g., `1.30`).
- `VPC_ID`: The ID of the VPC where the EKS cluster is deployed.
- `SUBNET_IDS`: Comma-separated list of subnet IDs (e.g., subnet-XXX,subnet-YYY) - access-subnet,availability-subnet.
- `LB_SUBNET_IDS`: Comma-separated list of subnet IDs for the load balancer - oam-subnet.
- `INSTANCE_TYPES`: Comma-separated list of instance types for the node group (e.g., `t3.medium,t3.large`).
- `LB_INTERNAL`: Boolean indicating if the load balancer should be internal (`true` or `false`).
- `AWS_LBC_POLICY_ARN`: The ARN of the IAM policy attached to the AWS Load Balancer Controller service account.

## Running on a Self-Hosted Runner

This workflow is designed to run on a self-hosted runner. Ensure your runner is properly configured and has the necessary tools installed as mentioned in the prerequisites.

## Notes

- The repository uses Terraform remote state stored in an S3 bucket to manage the infrastructure state.
- Ensure that the necessary IAM permissions are granted to the IAM user or role executing the GitHub Actions.

