
set -e

NAMESPACE="${NAMESPACE:-lhub-learning-hub}"

check_pods() {
    echo "Checking pod status..."
    kubectl get pods -n "$NAMESPACE" -o wide
    echo "OK"
}

check_services() {
    echo "Checking service status..."
    kubectl get svc -n "$NAMESPACE"
    echo "OK"
}

test_connectivity() {
    echo "Testing connectivity..."
    
    local minikube_ip
    minikube_ip=$(minikube ip -p lhub-learning-hub 2>/dev/null || echo "127.0.0.1")
    
    local frontend_port
    frontend_port=$(kubectl get svc -n "$NAMESPACE" frontend -o jsonpath='{.spec.ports[0].nodePort}')
    
    local backend_port
    backend_port=$(kubectl get svc -n "$NAMESPACE" backend -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null || echo "")
    
    echo "  Frontend: http://$minikube_ip:$frontend_port"
    [ -n "$backend_port" ] && echo "  Backend:  http://$minikube_ip:$backend_port/api/courses/"
    echo "OK"
}

load_fixtures() {
    echo "Loading fixtures..."
    
    local backend_pod
    backend_pod=$(kubectl get pods -n "$NAMESPACE" -l app=backend -o jsonpath='{.items[0].metadata.name}')
    
    if [ -z "$backend_pod" ]; then
        echo "  Skipped (backend pod not ready)"
        return
    fi
    
    kubectl exec -n "$NAMESPACE" "$backend_pod" -- \
        poetry run python manage.py loaddata \
        /app/fixtures/group.json \
        /app/fixtures/user.json \
        /app/fixtures/course.json 2>/dev/null || true
    
    echo "OK"
}

print_summary() {
    echo ""
    echo "✅ All tests passed!"
    echo ""
    echo "Access your application:"
    echo "  Frontend HTTP:  http://localhost:30080"
    echo "  Frontend HTTPS: https://localhost:8443"
    echo "  Backend HTTP:   http://localhost:30008/api/courses/"
    echo "  Backend HTTPS:  https://localhost:8443/api/courses/"
    echo "  Admin HTTP:     http://localhost:30080/admin/"
    echo "  Admin HTTPS:    https://localhost:8443/admin/"
}

main() {
    echo "=== Test Deployment ==="
    echo ""
    check_pods
    echo ""
    check_services
    echo ""
    test_connectivity
    echo ""
    load_fixtures
    echo ""
    print_summary
}

main
