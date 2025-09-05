# Overview

This is our solution for GCP Armageddon Task 2. We used Terraform code along with a cloudbuild.yaml to deploy a container image in Google Cloud Run. In order to deploy the different revisions with the desired 40/40/10/10 traffic split we have modified the yaml in several different branches named revision-1, revision-2, and revision-3 respectively. 


# Project Structure
main
├── templates/
│   └── index.html        # HTML template
├── terraform  
    └── deploy 
        └── backend.tf
            terraform-sa-key.json
            main.tf
            terraform.tfvars
            variables.tf
    └── infra 
        └── backend.tf
            terraform-sa-key.json
            main.tf
            terraform.tfvars
            variables.tf 
├── .env                  # Environment variables
├── .gitignore            # Ignore specified values
├── terraform-sa-key.json # Authenticates Terraform service account to GCP
├── cloudbuild.yaml       # Google Cloud Build instructions               
├── Dockerfile            # Docker build instructions
├── main.py               # Main Flask application, built with Python code
├── README.md             # This file
├── requirements.txt      # Python dependencies       



## .env file
```bash
HEADER_TEXT="My Awesome App"
IMAGE_URL=https://picsum.photos/400/300
FLASK_DEBUG=false
```

## Dependencies

- **Flask** - Web framework
- **python-dotenv** - Environment variable management
- **gunicorn** - WSGI server for production

## GCP APIs

- `gcloud services enable artifactregistry.googleapis.com`
- `gcloud services enable cloudbuild.googleapis.com`
- `gcloud services enable secretmanager.googleapis.com`

# Get Project ID and Number

To get GCP Project ID and Number execute the following command in your CLI:
- `gcloud projects list`
- `gcloud projects describe PROJECT_ID_YOU_WANT_TO_USE`

## GCP IAM Roles

- `gcloud projects add-iam-policy-binding PROJECT_ID --member="serviceAccount:service-PROJECT_NUMBER@gcp-sa-cloudbuild.iam.gserviceaccount.com" --role="roles/secretmanager.admin"`

# Connecting to Github
Initiate a connection to Github by executing the following command:

-`gcloud builds connections create github CONNECTION_NAME --region=REGION`

After running the gcloud builds connections command, you see a link to authorize the Cloud Build GitHub App.

Log into your github.com account.

Follow the link to authorize the Cloud Build GitHub App.

After authorizing the app, Cloud Build stores an authentication token as a secret in Secret Manager in your Google Cloud project. You can view your secrets on the Secret Manager page.

Install the Cloud Build GitHub App in your account or in an organization you own.

Permit the installation using your GitHub account and select repository permissions when prompted.

After you do this, you are free to close the window. If you want to verify the installation, run the following command:
-`gcloud builds connections describe CONNECTION_NAME --region=REGION`

# Variables
In the infra and deploy Terraform folders you must add the following variables:

Infra variables.tf:
```terraform
variable "project_id" {}

variable "region" {}

variable "repo_owner" {}

variable "repo_name" {}

variable "github_secret_name" {}

variable "github_url" {}

variable "github_installation_id" {}

variable "service_account" {}
```
Infra terraform.tfvars
```terraform
project_id = "Project ID here"
region = "Region youre working from here"
repo_owner = "Repository Owner Name"
repo_name = "Repository Name"
github_secret_name = "github-oauth-token-name"
github_url = "Github repository url"
github_installation_id = "8 digit string"
service_account = "terraform-service@PROJECT_ID.iam.gserviceaccount.com"
```

Deploy variables.tf:
```terraform
variable "project_id" {}

variable "region" {}
```
Deploy terraform.tfvars:
```terraform
project_id = "Project ID here"
region = "Region youre working from here"
```


# How to deploy
In main branch
-`cd terraform/infra`

```terraform 
terraform init

terraform validate

terraform plan

terraform apply -auto-approve
```
-`cd ../deploy`

Add a comment to any file, run `git add FILE_NAME` , `git commit -m "Commit message here"`, and `git push` for the cloud build trigger to activate. This will trigger Cloud Build to start creating the Cloud Run container. Make sure to comment out credentials in deploy folder, otherwise Terraform will not be able to recognize which credentials to use. 

Great! Now you must switch to the revision-1 branch. Run git switch revision-1 to switch to the other branch, and repeat the above steps for revision-2 and revision-3.

Congratulations! You now have a containerized application that has a traffic split.




