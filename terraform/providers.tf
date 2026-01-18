terraform {
    required_providers {
        kubernetes = {
            source = "hashicorp/kubernetes"
            version = "3.0.1"
        }
        tls = {
            source = "hashicorp/tls"
            version = "~> 4.0"
        }
    }
}

provider "kubernetes" {
    config_path = pathexpand("~/.kube/config")
}

resource "kubernetes_namespace_v1" "project_hub" {
    metadata {
        name = "${var.namespace_prefix}-${var.client}"
    }
}