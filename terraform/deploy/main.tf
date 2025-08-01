provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = "appdeploy-467712-21a6ba8a2566.json"
}

resource "google_cloud_run_service_iam_member" "default" {
  location = var.region
  project  = var.project_id
  service  = "cloudrun-service"
  role     = "roles/run.invoker"
  member   = "allUsers"
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
        value = "https://static1.srcdn.com/wordpress/wp-content/uploads/2022/09/Flash-Speed-Force-Running-DC-Comics.jpg?q=50&fit=crop&w=767&h=431&dpr=1.5"
      }

      env {
        name = "HEADER_TEXT"
        value = "Hello from Google Cloud Run!"
      }
    }
  }
}

# resource "google_cloud_run_service" "rev1" {
#   name     = "cloudrun-service"
#   location = var.region

#   metadata {
#     annotations = {
#       "run.googleapis.com/client-name" = "terraform"
#     }
#   }

#   template {
#     metadata {
#       name = "cloudrun-service-rev1"
#     }

#     spec {
#       containers {
#         image = "${var.region}-docker.pkg.dev/${var.project_id}/${data.google_artifact_registry_repository.flask-repo.repository_id}/cloudrunex"

#         env {
#           name  = "IMAGE_URL"
#           value = "https://static1.srcdn.com/wordpress/wp-content/uploads/2022/09/Flash-Speed-Force-Running-DC-Comics.jpg?q=50&fit=crop&w=767&h=431&dpr=1.5"
#         }

#         env {
#           name  = "HEADER_TEXT"
#           value = "Flash!"
#         }
#       }
#     }
#   }

#   traffic {
#     percent         = 100
#     latest_revision = true
#   }
# }

# resource "google_cloud_run_service" "rev2" {
#   name     = "cloudrun-service"
#   location = var.region

#   metadata {
#     annotations = {
#       "run.googleapis.com/client-name" = "terraform"
#     }
#   }

#   template {
#     metadata {
#       name = "cloudrun-service-rev2"
#     }

#     spec {
#       containers {
#         image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.flask-repo.repository_id}/cloudrunex"

#         env {
#           name  = "IMAGE_URL"
#           value = "https://static1.srcdn.com/wordpress/wp-content/uploads/2024/05/quicksilver-in-marvel-comics-running-and-grimacing.jpg"
#         }

#         env {
#           name  = "HEADER_TEXT"
#           value = "Quicksliver!"
#         }
#       }
#     }
#   }

#   traffic {
#     percent         = 100
#     latest_revision = true
#   }
# }

# resource "google_cloud_run_service" "traffic_split" {
#   name     = "cloudrun-service"
#   location = var.region

#   metadata {
#     annotations = {
#       "run.googleapis.com/client-name" = "terraform"
#     }
#   }

#   traffic {
#     revision_name = "cloudrun-service-rev1"
#     percent       = 50
#   }

#   traffic {
#     revision_name = "cloudrun-service-rev2"
#     percent       = 50
#   }

#   depends_on = [
#     google_cloud_run_service.rev1,
#     google_cloud_run_service.rev2
#   ]
# }