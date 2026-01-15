resource "kubernetes_secret_v1" "postgres_secret" {
  metadata {
    name = "postgres-secret"
  }

  data = {
    password = var.postgres_db_password
  }

  type = "Opaque"
}