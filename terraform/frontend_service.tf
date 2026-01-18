resource "kubernetes_service_v1" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace_v1.project_hub.metadata[0].name
    labels = {
      app = "frontend"
    }
  }

  spec {
    selector = {
      app = "frontend"
    }
    type = "NodePort"

    port {
      name        = "frontend"
      port        = var.frontend_port
      target_port = var.frontend_port
      node_port = 30080
    }
  }
}