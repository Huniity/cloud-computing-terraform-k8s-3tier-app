output "namespace" {
  description = "Kubernetes namespace where app is deployed"
  value       = kubernetes_namespace_v1.project_hub.metadata[0].name
}

output "frontend_service" {
  description = "Frontend service details"
  value = {
    name     = kubernetes_service_v1.frontend.metadata[0].name
    namespace = kubernetes_service_v1.frontend.metadata[0].namespace
    port     = kubernetes_service_v1.frontend.spec[0].port[0].node_port
    protocol = "http"
    replicas = kubernetes_deployment_v1.frontend.spec[0].replicas
  }
}

output "backend_service" {
  description = "Backend service details"
  value = {
    name     = kubernetes_service_v1.backend.metadata[0].name
    namespace = kubernetes_service_v1.backend.metadata[0].namespace
    port     = kubernetes_service_v1.backend.spec[0].port[0].node_port
    protocol = "http"
    replicas = kubernetes_deployment_v1.backend.spec[0].replicas
  }
}

output "database_service" {
  description = "Database service details"
  value = {
    name     = kubernetes_service_v1.database.metadata[0].name
    namespace = kubernetes_service_v1.database.metadata[0].namespace
    port     = kubernetes_service_v1.database.spec[0].port[0].node_port
    protocol = "postgresql"
    user     = "postgres"
    database = var.postgres_db_name
    replicas = kubernetes_stateful_set_v1.database.spec[0].replicas
  }
}

output "access_urls" {
  description = "Application access URLs"
  value = merge(
    {
      frontend   = "http://localhost:30080"
      backend_api = "http://localhost:30008/api/"
      admin      = "http://localhost:30080/admin/"
    },
    var.enable_https ? {
      frontend_https   = "https://localhost:8443"
      backend_api_https = "https://localhost:8443/api/"
      admin_https      = "https://localhost:8443/admin/"
    } : {}
  )
}

output "database_connection" {
  description = "Database connection information"
  value = {
    host                = "localhost"
    port                = 30432
    user                = "postgres"
    database            = var.postgres_db_name
    connection_string   = "postgresql://postgres@localhost:30432/${var.postgres_db_name}"
  }
  sensitive = true
}

output "kubernetes_context" {
  description = "Kubernetes cluster information"
  value = {
    namespace  = kubernetes_namespace_v1.project_hub.metadata[0].name
    cluster    = var.cluster_name
    context    = "minikube"
  }
}

output "images" {
  description = "Docker images deployed"
  value = {
    frontend = "${var.frontend_image}${var.image_tag}"
    backend  = "${var.backend_image}${var.image_tag}"
    database = "${var.database_image}${var.image_tag}"
  }
}

output "test_commands" {
  description = "Commands to test the deployment"
  value = {
    test_frontend  = "curl http://localhost:30080"
    test_api       = "curl http://localhost:30008/api/courses/"
    test_admin     = "curl http://localhost:30080/admin/"
    test_https_frontend = var.enable_https ? "curl -k https://${var.certificate_domain}" : null
    test_https_api      = var.enable_https ? "curl -k https://${var.certificate_domain}/api/courses/" : null
    test_https_admin    = var.enable_https ? "curl -k https://${var.certificate_domain}/admin/" : null
    port_forward   = "make port-forward"
  }
}
