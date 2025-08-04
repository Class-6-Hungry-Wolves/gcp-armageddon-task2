terraform {
  backend "gcs" {
    bucket      = "terraform-state-jourdan"
    prefix      = "terraform/deploy"
    #credentials = "appdeploy-467712-21a6ba8a2566.json"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}