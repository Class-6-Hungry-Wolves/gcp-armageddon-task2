terraform {
  backend "gcs" {
    bucket      = "terraformbucket61025"
    prefix      = "terraform/deploy"
    #credentials = "class65gcpproject-462600-3dd7a46c5330.json"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

#test