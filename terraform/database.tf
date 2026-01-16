resource "kubernetes_stateful_set_v1" "database" {
  metadata {
    name      = "database"
    namespace = kubernetes_namespace_v1.project_hub.metadata[0].name
    labels = {
      app = "database"
    }
  }

  spec {
    service_name = kubernetes_service_v1.database.metadata[0].name
    replicas     = var.database_replicas

    selector {
      match_labels = {
        app = "database"
      }
    }

    template {
      metadata {
        labels = {
          app = "database"
        }
      }

      spec {
        container {
          name              = "database"
          image             = "${var.database_image}${var.image_tag}"
          image_pull_policy = var.image_pull_policy

          port {
            name           = "postgres"
            container_port = var.postgres_db_port
          }

          env {
            name  = "POSTGRES_USER"
            value = var.postgres_db_user
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.postgres_secret.metadata[0].name
                key  = "password"
              }
            }
          }

          env {
            name  = "POSTGRES_DB"
            value = var.postgres_db_name
          }

          volume_mount {
            name       = "database-storage"
            mount_path = "/var/lib/postgresql/data"
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

    volume_claim_template {
      metadata {
        name = "database-storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "10Gi"
          }
        }
      }
    }
  }
}
