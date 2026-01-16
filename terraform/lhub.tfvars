# Learning Hub Terraform Variables
# General configuration
client = "learning-hub"
nodes = 3
namespace_prefix = "lhub"
namespace_name = "learning-hub-namespace"
workspace = "learning-hub-workspace"
# env = ["development", "staging", "production"]
addons = ["dashboard", "metrics-server", "ingress", "storage-provisioner", "registry"]
cluster_name = "learning-hub"
app_name = "learning-hub-app"
backend_app_name = "learning-hub-backend"


# Image configuration
database_image = "database"
database_image_path = "../app/database"
backend_image_path = "../app/backend"
backend_image = "backend"
frontend_image = "frontend"
frontend_image_path = "../app/frontend"
image_pull_policy = "IfNotPresent"
image_tag = ":latest"

# Database configuration
postgres_db_user     = "postgres"
postgres_db_password = "qwerty"
postgres_db_name     = "hub_db"
postgres_db_port     = 5432
postgres_db_host     = "database"
database_replicas = 1

# Backend configuration
backend_port = 8000
backend_replicas = 3
backend_django_debug = "False"
backend_django_settings_module = "learning_hub.settings"
django_secret_key = "django-insecure-_g!xn78w26aj^pw*$$2&^&fl_3wbtspd+3eay%2*3mgb4^u$jg"

# Frontend configuration
frontend_port = 80
frontend_replicas = 3