.PHONY: help setup apply test port-forward clean reset

help:
	@echo "Learning Hub - Makefile targets:"
	@echo ""
	@echo "  setup          Setup Minikube cluster"
	@echo "  apply          Deploy application with Terraform"
	@echo "  test           Test deployment and load fixtures"
	@echo "  port-forward   Setup port-forwards for local access"
	@echo "  clean          Delete cluster and clean state"
	@echo "  reset          Clean and start fresh"
	@echo ""
	@echo "Usage:"
	@echo "  make setup && make apply && make test"
	@echo ""

setup:
	bash scripts/setup.sh

apply:
	bash scripts/apply.sh

test:
	bash scripts/test.sh

port-forward:
	@echo "Setting up port-forwards..."
	@kubectl port-forward -n lhub-learning-hub svc/frontend 30080:80 --address=0.0.0.0 &
	@kubectl port-forward -n lhub-learning-hub svc/backend 30008:8000 --address=0.0.0.0 &
	@echo "✅ Port-forwards active:"
	@echo "  Frontend: http://localhost:30080"
	@echo "  Backend:  http://localhost:30008"

clean:
	bash scripts/cleanup.sh

reset: clean setup apply test