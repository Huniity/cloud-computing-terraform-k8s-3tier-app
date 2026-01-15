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


provider "minikube" {
}
provider "kubernetes" {
    host = minikube_cluster.project-hub-cluster.host

    client_certificate     = minikube_cluster.project-hub-cluster.client_certificate
    client_key             = minikube_cluster.project-hub-cluster.client_key
    cluster_ca_certificate = minikube_cluster.project-hub-cluster.cluster_ca_certificate
}



resource "minikube_cluster" "project-hub-cluster" {
    cluster_name = var.client
    nodes = var.nodes
}


resource "kubernetes_namespace_v1" "project-hub-cluster" {
    metadata {
        name = "${var.namespace_prefix}-${var.client}"
    }
}