terraform {
    required_providers {
        minikube = {
            source = "scott-the-programmer/minikube"
            version = "0.6.0"
        }
        kubernetes = {
            source = "hashicorp/kubernetes"
            version = "3.0.1"
    }
    }
}


provider "minikube" {}

resource "minikube_cluster" "project_hub_cluster" {
    cluster_name = var.client
    nodes = var.nodes
    addons = var.addons
}


provider "kubernetes" {
    host = minikube_cluster.project_hub_cluster.host
    client_certificate     = minikube_cluster.project_hub_cluster.client_certificate
    client_key             = minikube_cluster.project_hub_cluster.client_key
    cluster_ca_certificate = minikube_cluster.project_hub_cluster.cluster_ca_certificate
}


resource "kubernetes_namespace_v1" "project_hub" {
    metadata {
        name = "${var.namespace_prefix}-${var.client}"
    }
}