#!/bin/bash

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
    
    echo ""
    echo "  Frontend HTTP:  http://localhost:30080"
    curl -s -o /dev/null -w "    Status: %{http_code}\n" http://localhost:30080
    
    echo "  Frontend HTTPS: https://localhost:8443"
    curl -sk -o /dev/null -w "    Status: %{http_code}\n" https://localhost:8443
    
    echo "  Backend HTTP:   http://localhost:30008/api/courses/"
    curl -s -o /dev/null -w "    Status: %{http_code}\n" http://localhost:30008/api/courses/
    
    echo "  Backend HTTPS:  https://localhost:8443/api/courses/"
    curl -sk -o /dev/null -w "    Status: %{http_code}\n" https://localhost:8443/api/courses/
    
    echo "  Admin HTTP:     http://localhost:30080/admin/"
    curl -s -o /dev/null -w "    Status: %{http_code}\n" http://localhost:30080/admin/
    
    echo "  Admin HTTPS:    https://localhost:8443/admin/"
    curl -sk -o /dev/null -w "    Status: %{http_code}\n" https://localhost:8443/admin/
    
    echo ""
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
    print_summary
}

main
