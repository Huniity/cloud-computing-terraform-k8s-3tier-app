resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = "project-hub-ingress"
    namespace = kubernetes_namespace_v1.project_hub.metadata[0].name
  }

  spec {
    ingress_class_name = "nginx"
    
    dynamic "tls" {
      for_each = var.enable_https ? [1] : []
      content {
        hosts = [var.certificate_domain]
        secret_name = "learning-hub-tls"
      }
    }

    rule {
      host = var.certificate_domain
      http {
        path {
          path      = "/api"
          path_type = "Prefix"
          backend {
            service {
              name = "backend"
              port {
                number = 8000
              }
            }
          }
        }

        path {
          path      = "/admin"
          path_type = "Prefix"
          backend {
            service {
              name = "backend"
              port {
                number = 8000
              }
            }
          }
        }

        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "frontend"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_secret_v1.tls]
}