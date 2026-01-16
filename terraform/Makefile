.PHONY: apply plan setup cleanup test new workspace

apply:
	terraform apply lhub.plan

plan:
	terraform plan -var-file=lhub.tfvars -out lhub.plan

setup:
	terraform init

cleanup:
	terraform destroy lhub.plan

test:
	terraform validate

new:
	terraform workspace new lhub

workspace:
	terraform workspace list

reset:
	rm -rf .terraform .terraform.lock.hcl
	terraform init
	terraform apply -var-file=lhub.tfvars

build.images:
	cd /workspaces/cloud-computing-terraform-k8s-3tier-app/terraform
	terraform apply -var-file=lhub.tfvars