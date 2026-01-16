resource "kubernetes_secret_v1" "postgres_secret" {
  metadata {
    name = "postgres-secret"
    namespace = kubernetes_namespace_v1.project_hub.metadata[0].name
  }

  data = {
    password = var.postgres_db_password
  }

  type = "Opaque"
}