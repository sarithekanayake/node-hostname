
# BWT Platform Engineer Challenge

This repository uses Terraform, CloudFormation, and Helm chart configurations to provision and manage infrastructure and application deployments for the BWT Platform Engineer Challenge, leveraging GitHub Actions.

## Repository Overview

- **App Code**:
`src` contains the node-hostname application code.

- **Dockerfile**:
`Dockerfile` uses to create docker images of node-hostname application.
  - Using Alpine as the base image. Alpine image is a lightweight.
  - Version 24.4.0 is used for stability and predictability in deployments. 
  - A lightweight image is also beneficial from a security perspective, as it includes fewer dependencies.
  - Using /app as the Workdir and non-root node user to run the image.
  - Mount cache is a Docker buildkit feature and mount cache is configured to cache node package dependencies.
  - Both ENTRYPOINT and CMD have used for flexibility. 

- **Helm Chart**:
`helm\node-hostname` Helm chart installs K8s resources needed to run the node-hostname application. It sets up a Deployment, Service, and Ingress to expose the app through an HTTPS enabled ALB. EKS cluster uses the AWS Load Balancer Controller and ExternalDNS to automatically create the necessary components to make the app accessible over the internet. 

- **CloudFormation Template**:
Created `bootstrap.yaml` Cloudformation template to boostrap S3 bucket, dynamodb table and ECR repository creation. These resources will be used by the Terraform code as prerequisites.

- **Terraform**:
`infra` contains Terraform code to provision infrastructure in AWS account. 
  - Points to a separate repository which has version controlled Terraform modules: https://github.com/sarithekanayake/bwt-tf-modules.
  - base_values folder contains `values.yaml` file which uses for node-hostname Helm chart.

- **GitHub Action Workflow**:
`.github/workflows/main.yml` use as the GitHub pipeline for bootstrapping, Docker image build and push to ECR, infrastructure creation and application deployment. 



## Prerequisites

- GitHub account (https://gitlab.com/)
- AWS account (https://console.aws.amazon.com/)
- AWS CLI configured with Access Keys credentials (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- kubectl CLI (https://kubernetes.io/docs/tasks/tools/)


## How-to

### On GitHub official website
    1. Login into your GitHub account.
    2. Fork this repository to your GitHub space. 
    3. You will be automatically navigated to your forked GitHub repository.
    4. Navigate to `Secrets and variables` in Settings tab.
    5. Drop down `Secrets and variables` and select `Actions`.
    6. Click on `New repository secret`.
    7. Add `AWS_ACCESS_KEY_ID` and `SECRET_ACCESS_KEY` with the correct values.
    8. Update `S3BucketName` value of `.github/workflows/main.yml` with a unique S3 Bucket name.
    9. Commit the change to the `master` branch.
    10. Commit should trigger a new workflow execution.
    11. Wait for the workflow to complete.
    


### On the local machine
 
    1. Open up a new terminal window.
    2. Run `aws eks update-kubeconfig --region <region-code> --name <cluster-name>`. Replace the region and name of the EKS cluster with correct values.
    3. Now, should be able to interact with the EKS cluster using kubectl.



### Browser 
Visit https://bwt.sarithe.online (or the associated domain name) to access node-hostname application. The connection will automatically redirect to https://, as the application is configured with TLS/SSL. Certificate is issued by Amazon and managed through AWS Certificate Manager.