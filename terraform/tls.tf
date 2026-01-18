# Self-signed certificate for HTTPS
# Uses Terraform's tls provider for easy regeneration

# Generate private key
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Generate self-signed certificate
resource "tls_self_signed_cert" "main" {
  private_key_pem = tls_private_key.main.private_key_pem

  subject {
    common_name  = var.certificate_domain
    organization = "Learning Hub"
    country      = "US"
  }

  validity_period_hours = 8760  # 1 year
  is_ca_certificate     = false

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

# Create Kubernetes secret with certificate and key
resource "kubernetes_secret_v1" "tls" {
  metadata {
    name      = "learning-hub-tls"
    namespace = kubernetes_namespace_v1.project_hub.metadata[0].name
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = tls_self_signed_cert.main.cert_pem
    "tls.key" = tls_private_key.main.private_key_pem
  }
}

# Output certificate info for reference
output "tls_certificate_pem" {
  description = "Self-signed certificate (save as cert.pem)"
  value       = tls_self_signed_cert.main.cert_pem
  sensitive   = false
}

output "certificate_info" {
  description = "Certificate information"
  value = {
    domain     = var.certificate_domain
    valid_from = tls_self_signed_cert.main.validity_start_time
    valid_to   = tls_self_signed_cert.main.validity_end_time
    subject    = "CN=${var.certificate_domain}, OU=Learning Hub"
  }
}
