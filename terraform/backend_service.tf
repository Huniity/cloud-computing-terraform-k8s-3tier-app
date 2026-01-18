resource "kubernetes_service_v1" "backend" {
  metadata {
    name      = "backend"
    namespace = kubernetes_namespace_v1.project_hub.metadata[0].name
    labels = {
      app = "backend"
    }
  }

  spec {
    selector = {
      app = "backend"
    }
    type = "ClusterIP"

    port {
      name        = "backend"
      port        = var.backend_port
      target_port = var.backend_port
    }
  }
}