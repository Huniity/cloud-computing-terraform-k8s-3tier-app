resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = "project-hub-ingress"
    namespace = kubernetes_namespace_v1.project_hub.metadata[0].name
  }

  spec {
    ingress_class_name = "nginx"
    
    tls {
      hosts = ["project-hub"]
      secret_name = "project-hub-tls"
    }

    rule {
      host = "project-hub"
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

    rule {
      host = "localhost"
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
}