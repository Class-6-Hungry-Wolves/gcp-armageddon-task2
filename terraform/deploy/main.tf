provider "google" {
  project     = var.project_id
  region      = var.region
  # credentials = "class65gcpproject-462600-3dd7a46c5330.json"
}

resource "google_cloud_run_service_iam_member" "default" {
  location = var.region
  project  = var.project_id
  service  = "cloudrun-service"
  role     = "roles/run.invoker"
  member   = "allUsers"
  depends_on = [ google_cloud_run_v2_service.default ]
}
data "google_artifact_registry_repository" "flask-repo" {
  location      = var.region
  repository_id = "flask-repository"
}
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service"
  location = var.region
  deletion_protection = false
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${data.google_artifact_registry_repository.flask-repo.repository_id}/cloudrunex"

      env {
        name  = "FLASK_DEBUG"
        value = "false"
      }

      env {
        name  = "IMAGE_URL"
        value = "https://i.imgur.com/WFerKd7.jpeg"
      }

      env {
        name = "HEADER_TEXT"
        value = "Miami Here We Come!"
      }
    }
  }
