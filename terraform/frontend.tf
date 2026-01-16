resource "kubernetes_deployment_v1" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace_v1.project_hub.metadata[0].name
    labels = {
      app = "frontend"
    }
  }

  spec {
    replicas = var.frontend_replicas

    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }

      spec {
        container {
          name              = "frontend"
          image             = "${var.frontend_image}${var.image_tag}"
          image_pull_policy = var.image_pull_policy

          port {
            name           = "http"
            container_port = var.frontend_port
          }

          resources {
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "128Mi"
            }
          }

          volume_mount {
            name = "nginx-config-volume"
            mount_path = "/etc/nginx/conf.d/default.conf"
            sub_path = "nginx.conf"
          }
        }
        volume {
            name = "nginx-config-volume"
            config_map {
                name = kubernetes_config_map_v1.nginx_config.metadata[0].name 
            }
        }
      }
    }
  }
}