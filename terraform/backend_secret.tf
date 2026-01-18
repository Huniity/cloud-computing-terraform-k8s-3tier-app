resource "kubernetes_secret_v1" "backend_secret" {
  metadata {
    name = "backend-secret"
    namespace = kubernetes_namespace_v1.project_hub.metadata[0].name
  }

  data = {
    password = var.postgres_db_password
    secret_key = var.django_secret_key
  }

  type = "Opaque"
}