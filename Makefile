.PHONY: apply plan setup cleanup test new workspace

apply:
	terraform apply ./terraform/lhub.plan

plan:
	terraform plan -var-file=./terraform/lhub.tfvars -out ./terraform/lhub.plan

setup:
	terraform init

cleanup:
	terraform destroy ./terraform/lhub.plan

test:
	terraform validate

new:
	terraform workspace new lhub

workspace:
	terraform workspace list
