# Learning Hub - Infrastructure as Code

![Terraform](https://img.shields.io/badge/Terraform-1.0%2B-623ce4)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Latest-326ce5)
![Minikube](https://img.shields.io/badge/Minikube-Latest-1d63ed)
![Django](https://img.shields.io/badge/Django-5.1.7-0c4b33)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-336791)

## Overview

Complete Infrastructure as Code (IaC) for deploying the Learning Hub application - a 3-tier course management system on Kubernetes using Terraform.

**Components:**
- **Frontend** - Nginx-based web UI
- **Backend** - Django REST API
- **Database** - PostgreSQL
- **Infrastructure** - Terraform on Minikube

## Relationship to Previous Exercise

This project builds upon the manual Kubernetes deployment from the previous exercise:

### What's Reused
- ✅ **Application Code** - Same Django backend, Nginx frontend, PostgreSQL database
- ✅ **Docker Images** - Same Dockerfiles for all 3 services
- ✅ **Kubernetes Manifests** - Translated YAML deployments, services, configmaps into Terraform files
- ✅ **Database Schema** - Same PostgreSQL initialization scripts
- ✅ **Test Fixtures** - Same courses, users, and groups data

### What's Different
- 🔄 **Infrastructure Management** - Manual `kubectl apply` → Automated Terraform
- 🔄 **State Management** - Kubectl deployments → Terraform state tracking
- 🔄 **Reproducibility** - Manual steps → Repeatable IaC workflows
- 🔄 **Scalability** - Fixed config → Parameterized variables
- 🔄 **Destruction** - Manual cleanup → Automated teardown

**Manual kubectl approach (previous exercise):**
```bash
# Had to apply each manifest individually:
kubectl apply -f app/backend/deployment.yaml
kubectl apply -f app/backend/service.yaml
kubectl apply -f app/frontend/deployment.yaml
kubectl apply -f app/frontend/service.yaml
kubectl apply -f app/database/statefulset.yaml
kubectl apply -f app/database/service.yaml
# ... and more - error-prone and hard to track
```

**Terraform approach (this project):**
```bash
# Single command handles all resources:
terraform apply -var-file=lhub.tfvars
# Terraform tracks state, dependencies, and enables reproducible deployments
```

### Key Improvements
| Aspect | Manual (k8s) | IaC (Terraform) |
|--------|--------------|-----------------|
| Deployment | `kubectl apply` × N | `make apply` |
| Teardown | Manual deletion | `make clean` |
| Variables | Hardcoded in YAML | Configurable `.tfvars` |
| State Tracking | None | Terraform state files |
| Version Control | YAML files | Terraform + Variables |
| Reproducibility | Error-prone | Guaranteed |
| Documentation | Manual notes | Generated outputs |


## Known Limitations

### Development Only
- Uses Minikube (single-node local cluster) - not production-ready
- Image build locally not pushed to DockerHub
- Secrets stored in Terraform state (not encrypted)
- Self-signed TLS certificates

### Database
- PostgreSQL runs as StatefulSet with 1 replica (not highly available)
- No automated backups configured
- Persistent volume relies on Minikube's storage

### Networking
- Ingress controller configured but uses simple nginx routing
- Database port exposed locally via port-forward only

### Scalability
- Minikube limited memory
- Resource requests/limits are minimal

## Architecture

```
┌────────────────────────────────────────────────────────────┐
│                    Host Machine                            │
│                  (localhost)                               │
└────────────────────┬───────────────────────────────────────┘
                     │
        ┌────────────┼────────────┐
        ▼            ▼            ▼
   ┌─────────┐  ┌──────────┐  ┌──────────┐
   │Frontend │  │ Backend  │  │ Database │
   │:30080   │  │  :30008  │  │  :30432  │
   └─────────┘  └──────────┘  └──────────┘
        │            │            │
        └────────────┼────────────┘
                     │
        ┌────────────▼────────────┐
        │  Minikube Cluster       │
        │  (Kubernetes)           │
        │  Namespace: lhub-xxxxx  │
        └─────────────────────────┘
```

## Prerequisites

- Docker (running)
- kubectl (installed)
- Minikube (installed)
- Terraform (installed)

## Quick Start

Deploy everything in one command:

```bash
make reset
```

Or step-by-step:

```bash
make setup       # bash scripts/setup.sh
make apply       # bash scripts/apply.sh
make test        # bash scripts/test.sh
```

## Usage

### Setup Phase
Initialize Minikube with required addons:

```bash
make setup  # bash scripts/setup.sh
```

**What it does:**
- Starts Minikube cluster (4 CPUs, 6GB memory)
- Enables metrics-server addon
- Enables ingress addon
- Enables storage-provisioner addon

### Deploy Phase
Deploy infrastructure with Terraform:

```bash
make apply  # bash scripts/apply.sh
```

**What it does:**
- Initializes Terraform
- Plans deployment
- Applies Kubernetes manifests
- Creates namespace, services, deployments

### Test Phase
Verify deployment and load test data:

```bash
make test  # bash scripts/test.sh
```

**What it does:**
- Checks pod status
- Verifies services
- Shows access URLs
- Loads database fixtures (groups, users, courses)

### Port Forwarding
Enable local access to services:

```bash
make port-forward  # kubectl port-forward commands
```

**What it provides:**
- Frontend: http://localhost:30080
- Backend API: http://localhost:30008
- Database: postgresql://localhost:30432

## Access the Application

After deployment, access via:

| Service | URL | Port |
|---------|-----|------|
| Frontend | http://localhost:30080 | 30080 |
| Backend API | http://localhost:30008/api/ | 30008 |
| Admin | http://localhost:30080/admin/ | 30080 |
| Database | localhost | 30432 |

### HTTPS

Self-signed certificate is enabled by default. Access via `https://localhost` (ignore browser warning).

To customize or disable:
```bash
# In lhub.tfvars:
certificate_domain = "learning-hub.local"   # change domain
enable_https = false                        # disable HTTPS
```

### Test Credentials

Available after running `make test`:

- **Admin**: `admin` / (set during setup)
- **Mentor**: `Mentor` / `password`
- **Student**: `Student` / `password`
- **Student2**: `Student2` / `password`

## File Structure

```
.
├── README.md                 # This file
├── Makefile                  # Make targets
├── scripts/
│   ├── setup.sh             # Initialize Minikube
│   ├── apply.sh             # Deploy with Terraform
│   ├── test.sh              # Test deployment
│   └── cleanup.sh           # Delete all resources
├── terraform/
│   ├── main.tf              # Main configuration
│   ├── variables.tf         # Input variables
│   ├── outputs.tf           # Output values
│   ├── providers.tf         # Terraform providers
│   ├── images.tf            # Docker image builds
│   ├── lhub.tfvars          # Cluster configuration
│   └── *.tf                 # Additional resources
└── app/
    ├── backend/             # Django REST API
    ├── frontend/            # Nginx web UI
    ├── database/            # PostgreSQL init
    └── scripts/             # K8s manifests
```

## Environment Variables

Configure cluster properties:

```bash
# Setup phase
CLUSTER_NAME=my-cluster
MINIKUBE_CPUS=4
MINIKUBE_MEMORY=6144

# Terraform phase
TF_VARS=lhub.tfvars

# Test phase
NAMESPACE=lhub-learning-hub
```

Example:

```bash
CLUSTER_NAME=dev MINIKUBE_CPUS=8 make setup
TF_VARS=custom.tfvars make apply
NAMESPACE=custom-ns make test
```

## Terraform Outputs

After `make apply`, Terraform displays:

```hcl
frontend_service = {
  name      = "frontend"
  port      = 30080
  replicas  = 2
}

backend_service = {
  name      = "backend"
  port      = 30008
  replicas  = 2
}

database_service = {
  name      = "database"
  port      = 30432
  replicas  = 1
}

access_urls = {
  frontend   = "http://localhost:30080"
  backend_api = "http://localhost:30008/api/"
  admin      = "http://localhost:30080/admin/"
}

test_commands = {
  test_frontend = "curl http://localhost:30080"
  test_api      = "curl http://localhost:30008/api/courses/"
}
```

## Cleanup

Remove all resources:

```bash
make clean  # bash scripts/cleanup.sh
```

**What it removes:**
- Minikube cluster (`minikube delete -p lhub-learning-hub`)
- Terraform state files (`.terraform`, `*.tfstate`)
- Docker images and volumes (`docker system prune`)
- Local port-forwards (kills `kubectl port-forward` processes)

### Manual Cleanup

If you need to clean up individually:

```bash
# Stop port-forwards
pkill -f "kubectl port-forward"

# Delete the cluster
minikube delete -p lhub-learning-hub

# Clean Terraform state
rm -rf terraform/.terraform
rm -f terraform/*.tfstate*
rm -f terraform/.terraform.lock.hcl

# Prune Docker (optional)
docker system prune -a --volumes -f
```

### Verify Complete Cleanup

```bash
# Check cluster is gone
minikube profile list | grep lhub-learning-hub

# Check Terraform state is gone
ls -la terraform/*.tfstate

# Check docker is clean
docker images | grep -E "frontend|backend|database"
```

## Troubleshooting

### Pods not running?

```bash
kubectl get pods -n lhub-learning-hub
kubectl logs -n lhub-learning-hub <pod-name>
```

### Port-forward issues?

```bash
# Kill existing forwards
pkill -f "kubectl port-forward"

# Restart
kubectl port-forward -n lhub-learning-hub svc/frontend 30080:80 --address=0.0.0.0 &
kubectl port-forward -n lhub-learning-hub svc/backend 30008:8000 --address=0.0.0.0 &
```

### Terraform state conflicts?

```bash
make reset  # make clean && make setup && make apply && make test
```

### Database connection issues?

```bash
# Check database pod
kubectl describe pod -n lhub-learning-hub database-0

# Port forward directly
kubectl port-forward -n lhub-learning-hub svc/database 30432:5432 --address=0.0.0.0
```

## Development

### View Kubernetes Dashboard

```bash
minikube dashboard -p lhub-learning-hub
```

### Monitor with k9s

```bash
k9s -n lhub-learning-hub
```

### Run custom Terraform commands

```bash
cd terraform
terraform plan -var-file=lhub.tfvars
terraform apply
terraform destroy
```

## Scripts Reference

### setup.sh
- `start_cluster()` - Start Minikube
- `enable_addons()` - Enable required addons
- `print_info()` - Display setup info

### apply.sh
- `init_terraform()` - Initialize Terraform
- `plan_deployment()` - Create deployment plan
- `apply_deployment()` - Apply configuration
- `show_outputs()` - Display outputs

### test.sh
- `check_pods()` - Verify pod status
- `check_services()` - Verify services
- `test_connectivity()` - Show access URLs
- `load_fixtures()` - Load test data
- `print_summary()` - Display summary

### cleanup.sh
- `kill_port_forwards()` - Stop port-forwards
- `delete_cluster()` - Delete Minikube
- `clean_terraform()` - Remove state files
- `clean_debug_files()` - Remove logs
- `clean_docker()` - Prune Docker

## Configuration Files

### lhub.tfvars

Customize cluster deployment:

```hcl
client = "learning-hub"
namespace_prefix = "lhub"
cluster_name = "learning-hub"

# Database
postgres_db_user = "postgres"
postgres_db_name = "hub_db"

# Backend replicas
backend_replicas = 3

# Frontend replicas
frontend_replicas = 3
```

## Support & Next Steps

1. **Review app/README.md** - Backend/Frontend documentation
2. **Check terraform/** - Infrastructure code
3. **View app/scripts/** - Kubernetes manifests
4. **Run make help** - See all available targets


## Support & Next Steps

1. **Review app/README.md** - Backend/Frontend documentation
2. **Check terraform/** - Infrastructure code
3. **View app/scripts/** - Kubernetes manifests
4. **Read Makefile** - See all available targets

## License

See LICENSE file for details.
