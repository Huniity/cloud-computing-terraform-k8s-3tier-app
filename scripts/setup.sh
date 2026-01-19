#!/bin/bash

set -e

CLUSTER_NAME="${CLUSTER_NAME:-lhub-learning-hub}"
MINIKUBE_CPUS="${MINIKUBE_CPUS:-4}"
MINIKUBE_MEMORY="${MINIKUBE_MEMORY:-6144}"

start_cluster() {
    echo "Starting Minikube cluster..."
    minikube start -p "$CLUSTER_NAME" \
      --cpus="$MINIKUBE_CPUS" \
      --memory="$MINIKUBE_MEMORY" \
      --driver=docker
    echo "OK"
}

enable_addons() {
    echo "Enabling addons..."
    minikube addons enable ingress -p "$CLUSTER_NAME"
    minikube addons enable storage-provisioner -p "$CLUSTER_NAME"
    echo "OK"
}

print_info() {
    echo ""
    echo "Cluster setup complete:"
    echo "  Name: $CLUSTER_NAME"
    echo "  CPUs: $MINIKUBE_CPUS"
    echo "  Memory: ${MINIKUBE_MEMORY}MB"
    echo ""
    echo "Next: run make apply"
}

main() {
    echo "=== Setup Minikube ==="
    echo ""
    start_cluster
    echo ""
    enable_addons
    echo ""
    print_info
}

main
