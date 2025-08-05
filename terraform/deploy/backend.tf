terraform {
  backend "gcs" {
    bucket      = "terraformbucket61025"
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

#test