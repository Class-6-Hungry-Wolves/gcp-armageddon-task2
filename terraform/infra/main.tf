provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = "class65gcpproject-462600-3dd7a46c5330.json"
}

# test
resource "google_artifact_registry_repository" "flask-repo" {
  location      = var.region
  repository_id = "flask-repository"
  description   = "docker repository for flask app"
  format        = "DOCKER"
}

resource "google_cloudbuildv2_connection" "github-connection" {
  location = var.region
  name     = "github-connection"

  github_config {
    app_installation_id = var.github_installation_id
    authorizer_credential {
      oauth_token_secret_version = "projects/${var.project_id}/secrets/${var.github_secret_name}/versions/latest"
    }
  }
}

resource "google_cloudbuildv2_repository" "flask-repository" {
  name              = "cloud-run-ex"
  parent_connection = google_cloudbuildv2_connection.github-connection.id
  remote_uri        = var.github_url
}

resource "google_cloudbuild_trigger" "flask-repo-trigger" {
  location        = var.region
  service_account = "projects/${var.project_id}/serviceAccounts/${var.service_account}"

  repository_event_config {
    repository = google_cloudbuildv2_repository.flask-repository.id
    push {
      branch = "revision-3"
    }
  }

  filename = "cloudbuild.yaml"

  substitutions = {
    _REGION     = var.region
    _REPO_NAME  = google_artifact_registry_repository.flask-repo.repository_id
    _IMAGE_NAME = "cloudrunex"
  }
}

