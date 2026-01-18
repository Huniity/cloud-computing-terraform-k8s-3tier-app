resource "kubernetes_deployment_v1" "backend" {
  metadata {
    name      = "backend"
    namespace = kubernetes_namespace_v1.project_hub.metadata[0].name
    labels = {
      app = "backend"
    }
  }

  spec {
    replicas = var.backend_replicas

    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }

      spec {
        container {
          name              = "backend"
          image             = "${var.backend_image}${var.image_tag}"
          image_pull_policy = var.image_pull_policy

          port {
            name           = "http"
            container_port = var.backend_port
          }

          env {
            name  = "DJANGO_SETTINGS_MODULE"
            value = var.backend_django_settings_module
          }

          env {
            name  = "DJANGO_DEBUG"
            value = var.backend_django_debug
          }

          env {
            name  = "POSTGRES_HOST"
            value = kubernetes_service_v1.database.metadata[0].name
          }

          env {
            name  = "POSTGRES_PORT"
            value = tostring(var.postgres_db_port)
          }

          env {
            name  = "POSTGRES_DB"
            value = var.postgres_db_name
          }

          env {
            name  = "POSTGRES_USER"
            value = var.postgres_db_user
          }

          env {
            name  = "ALLOWED_HOSTS"
            value = "*"
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.backend_secret.metadata[0].name
                key  = "password"
              }
            }
          }

          env {
            name = "SECRET_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.backend_secret.metadata[0].name
                key  = "secret_key"
              }
            }
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
}