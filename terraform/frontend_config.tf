resource "kubernetes_config_map_v1" "nginx_config" {
  metadata {
    name      = "nginx-config"
    namespace = kubernetes_namespace_v1.project_hub.metadata[0].name
  }

  data = {
    "nginx.conf" = <<-EOT
      server {
        listen 80;
        server_name _;

        resolver 10.96.0.10 valid=10s ipv6=off;

        root /usr/share/nginx/html;
        index index.html;

        location /static/ {
          alias /usr/share/nginx/html/static/;
          expires 1h;
          add_header Cache-Control "public";
        }

        location /api/ {
          set $backend_upstream http://${kubernetes_service_v1.backend.metadata[0].name}.${kubernetes_namespace_v1.project_hub.metadata[0].name}.svc.cluster.local:${var.backend_port};
          proxy_pass $backend_upstream;

          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header Authorization $http_authorization;

          proxy_redirect off;
          proxy_connect_timeout 5s;
          proxy_read_timeout 30s;
        }

        location = /admin {
          return 301 /admin/;
        }

        location /admin/ {
          set $backend_upstream http://${kubernetes_service_v1.backend.metadata[0].name}.${kubernetes_namespace_v1.project_hub.metadata[0].name}.svc.cluster.local:${var.backend_port};
          proxy_pass $backend_upstream;

          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header Authorization $http_authorization;

          proxy_redirect off;
          proxy_connect_timeout 5s;
          proxy_read_timeout 30s;
        }

        location / {
          try_files $uri $uri/ /index.html;
        }
      }
    EOT
  }
}
