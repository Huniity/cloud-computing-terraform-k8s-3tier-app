#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TF_DIR="$PROJECT_ROOT/terraform"
TF_VARS="${TF_VARS:-lhub.auto.tfvars}"

init_terraform() {
    echo "Initializing Terraform..."
    cd "$TF_DIR"
    terraform init
    echo "OK"
}

plan_deployment() {
    echo "Planning deployment..."
    cd "$TF_DIR"
    terraform plan -var-file="$TF_VARS" -out=tfplan
    echo "OK"
}

apply_deployment() {
    echo "Applying configuration..."
    cd "$TF_DIR"
    terraform apply tfplan
    echo "OK"
}

show_outputs() {
    echo ""
    echo "Deployment outputs:"
    cd "$TF_DIR"
    terraform output
    echo ""
}

start_port_forwards() {
    echo "Starting port-forwards in background..."
    bash "$SCRIPT_DIR/port-forward.sh" start &
    echo "Next: run make test"
}

main() {
    echo "=== Apply Terraform ==="
    echo ""
    init_terraform
    echo ""
    plan_deployment
    echo ""
    apply_deployment
    echo ""
    show_outputs
    echo ""
    start_port_forwards
}

main
