provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = "appdeploy-467712-21a6ba8a2566.json"
}

resource "google_artifact_registry_repository" "flask-repo" {
  location      = var.region
  repository_id = "flask-repository"
  description   = "docker repository for flask app"
  format        = "DOCKER"
}

resource "google_cloudbuildv2_connection" "github-connection" {
  location = "us-central1"
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
  location = var.region
  service_account = "projects/${var.project_id}/serviceAccounts/${var.service_account}"

  repository_event_config {
    repository = google_cloudbuildv2_repository.flask-repository.id
    push {
      branch = "main"
    }
  }

  filename = "cloudbuild.yaml"

  substitutions = {
    _REGION     = var.region
    _REPO_NAME =  google_artifact_registry_repository.flask-repo.repository_id
    _IMAGE_NAME = "cloudrunex"
  }
}

resource "google_cloud_run_service_iam_member" "default" {
  location = var.region
  project  = var.project_id
  service  = "cloudrun-service"
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service"
  location = var.region
  deletion_protection = false
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.flask-repo.repository_id}/cloudrunex"

      env {
        name  = "FLASK_DEBUG"
        value = "false"
      }

      env {
        name  = "IMAGE_URL"
        value = "https://screenrant.com/flash-wasting-his-speed-running-on-air-water-earth/"
      }

      env {
        name = "HEADER_TEXT"
        value = "Hello from Google Cloud Run!"
      }
    }
  }
}