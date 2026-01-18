#!/bin/bash

set -e

NAMESPACE="${NAMESPACE:-lhub-learning-hub}"

start_port_forwards() {
    echo "Setting up port-forwards..."
    kubectl port-forward -n "$NAMESPACE" svc/frontend 30080:80 --address=0.0.0.0 &
    kubectl port-forward -n "$NAMESPACE" svc/backend 30008:8000 --address=0.0.0.0 &
    kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8443:443 --address=0.0.0.0 2>/dev/null &
    sleep 1
    echo "✅ Port-forwards active:"
    echo "  Frontend HTTP: http://localhost:30080"
    echo "  Frontend HTTPS: https://localhost:8443"
    echo "  Backend HTTP:   http://localhost:30008"
    echo "  Backend HTTPS:  https://localhost:8443"
    echo ""
    echo "Test HTTPS:"
    echo "  curl -k https://localhost:8443"
    echo "  curl -k https://localhost:8443/api/courses/"
    echo "  curl -k https://localhost:8443/admin/"
}

stop_port_forwards() {
    echo "Stopping port-forwards..."
    pkill -f "kubectl port-forward" || true
    echo "✅ Port-forwards stopped"
}

main() {
    case "${1:-start}" in
        start)
            start_port_forwards
            ;;
        stop)
            stop_port_forwards
            ;;
        *)
            echo "Usage: $0 {start|stop}"
            exit 1
            ;;
    esac
}

main "$@"
