resource "kubernetes_job_v1" "backend_bootstrap" {
  metadata {
    name      = "backend-bootstrap"
    namespace = kubernetes_namespace_v1.project_hub.metadata[0].name
  }

  spec {
    backoff_limit = 1

    template {
      metadata {
        annotations = {
          backend_hash = local.backend_hash
        }
      }

      spec {
        restart_policy = "Never"

        container {
          name  = "backend-bootstrap"
          image = "${var.backend_image}${var.image_tag}"
          image_pull_policy = var.image_pull_policy

          env {
            name  = "DJANGO_SETTINGS_MODULE"
            value = var.backend_django_settings_module
          }
          env {
            name  = "DJANGO_DEBUG"
            value = var.backend_django_debug
          }
          env {
            name  = "POSTGRES_HOST"
            value = var.postgres_db_host
          }
          env {
            name  = "POSTGRES_PORT"
            value = tostring(var.postgres_db_port)
          }
          env {
            name  = "POSTGRES_DB"
            value = var.postgres_db_name
          }
          env {
            name  = "POSTGRES_USER"
            value = var.postgres_db_user
          }
          env {
            name  = "ALLOWED_HOSTS"
            value = "*"
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.backend_secret.metadata[0].name
                key  = "password"
              }
            }
          }

          env {
            name = "SECRET_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.backend_secret.metadata[0].name
                key  = "secret_key"
              }
            }
          }

          command = ["/bin/sh", "-lc"]
          args = [<<-EOT
            set -e
            cd /app
            PY="$(ls -1 /root/.cache/pypoetry/virtualenvs/*/bin/python | head -n 1)"

            echo "Using: $PY"
            $PY manage.py migrate --noinput

            if [ -d fixtures ]; then
              FIX=fixtures
            elif [ -d backend/fixtures ]; then
              FIX=backend/fixtures
            else
              echo "No fixtures folder found; done."
              exit 0
            fi

            $PY manage.py loaddata "$FIX/group.json"
            $PY manage.py loaddata "$FIX/user.json"
            $PY manage.py loaddata "$FIX/course.json"

            echo "Bootstrap done."
          EOT
          ]
        }
      }
    }
  }

  depends_on = [
    null_resource.main_images,
    kubernetes_stateful_set_v1.database,
    kubernetes_service_v1.database,
    kubernetes_secret_v1.backend_secret
  ]

  # make terraform recreate the job when backend changes
  lifecycle {
    replace_triggered_by = [null_resource.main_images]
  }
}
