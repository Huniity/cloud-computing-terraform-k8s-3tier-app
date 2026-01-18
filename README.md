minikube start --driver=docker --cpus=4 --memory=8192 2>&1 | tail -10
cd /workspaces/cloud-computing-terraform-k8s-3tier-app/terraform && terraform init 2>&1 | tail -15
cd /workspaces/cloud-computing-terraform-k8s-3tier-app/terraform && terraform validate
cd /workspaces/cloud-computing-terraform-k8s-3tier-app/terraform && terraform plan -var-file=lhub.tfvars -out=lhub.plan 2>&1 | grep -E "Plan:|No changes|error|Error" | head -5
cd /workspaces/cloud-computing-terraform-k8s-3tier-app/terraform && terraform apply lhub.plan 2>&1