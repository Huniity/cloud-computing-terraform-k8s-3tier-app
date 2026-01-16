resource "kubernetes_service_v1" "database" {
  metadata {
    name      = "database"
    namespace = kubernetes_namespace_v1.project_hub.metadata[0].name
    labels = {
      app = "database"
    }
  }

  spec {
    cluster_ip = "None"

    selector = {
      app = "database"
    }

    port {
      name        = "postgres"
      port        = var.postgres_db_port
      target_port = var.postgres_db_port
    }
  }
}