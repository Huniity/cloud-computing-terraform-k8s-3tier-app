
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TF_DIR="$PROJECT_ROOT/terraform"
CLUSTER_NAME="${CLUSTER_NAME:-lhub-learning-hub}"

kill_port_forwards() {
    echo "Stopping port-forwards..."
    pkill -f "kubectl port-forward" || true
    echo "OK"
}

delete_cluster() {
    echo "Deleting Minikube cluster..."
    minikube delete -p "$CLUSTER_NAME" 2>/dev/null || true
    echo "OK"
}

clean_terraform() {
    echo "Cleaning Terraform state..."
    rm -rf "$TF_DIR/.terraform"
    rm -f "$TF_DIR/.terraform.lock.hcl"
    rm -f "$TF_DIR/terraform.tfstate"
    rm -f "$TF_DIR/terraform.tfstate.backup"
    rm -f "$TF_DIR/lhub.plan"
    rm -f "$TF_DIR/tfplan"
    rm -f "$TF_DIR/.terraform.tfstate.lock.info"
    echo "OK"
}

clean_debug_files() {
    echo "Cleaning debug files..."
    rm -f "$TF_DIR/crash.log"
    rm -f "$TF_DIR"/*.log
    rm -rf "$TF_DIR/debug"
    echo "OK"
}

clean_docker() {
    echo "Cleaning Docker images and volumes..."
    docker system prune -a --volumes -f > /dev/null 2>&1 || true
    echo "OK"
}

print_summary() {
    echo ""
    echo "✅ Cleanup complete!"
    echo "Fresh start ready: run make setup"
}

main() {
    echo "=== Cleanup All ==="
    echo ""
    kill_port_forwards
    echo ""
    delete_cluster
    echo ""
    clean_terraform
    echo ""
    clean_debug_files
    echo ""
    clean_docker
    echo ""
    print_summary
}

main
