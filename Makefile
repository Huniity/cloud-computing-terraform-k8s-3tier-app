.PHONY: help setup apply test port-forward stop-port-forward clean reset

help:
	@echo "Learning Hub - Makefile targets:"
	@echo ""
	@echo "  setup              Setup Minikube cluster"
	@echo "  apply              Deploy application with Terraform"
	@echo "  test               Test deployment and load fixtures"
	@echo "  port-forward       Start port-forwards"
	@echo "  stop-port-forward  Stop port-forwards"
	@echo "  clean              Delete cluster and clean state"
	@echo "  reset              Clean and start fresh"
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
	bash scripts/port-forward.sh start

stop-port-forward:
	bash scripts/port-forward.sh stop

clean:
	bash scripts/cleanup.sh

reset: clean setup apply test