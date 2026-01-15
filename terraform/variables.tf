# General configuration variables

variable "nodes" {
    description = "Number of nodes in the Minikube cluster"
    type = number
    default = 1
}

variable "client" {
    description = "Clients name"
    type = string
    default = "default-client"
}

variable "cluster_name" {
    description = "Name of the Minikube cluster"
    type = string
    default = "default-cluster"
}

variable "app_name" {
    description = "Application name"
    type = string
    default = "DefaultApp"
}

variable "namespace_prefix" {
    description = "Prefix for Kubernetes namespace"
    type = string
    default = "app"
}

variable "namespace_name" {
    description = "Full name for Kubernetes namespace"
    type = string
    default = "default-namespace"
}

variable "workspace" {
    description = "Workspace name"
    type = string
    default = "development-workspace"
}

variable "env" {
    description = "Environment name"
    type = string
    default = "default-environment"
}

variable "addons" {
    description = "List of Minikube addons to enable"
    type = list(string)
    default = []
}

# Image configuration variables

variable "database_image" {
    description = "Docker image for database service"
    type = string
    default = "database:latest"
    nullable = false
}

variable "database_image_path" {
    description = "Path to Dockerfile for database service"
    type = string
    default = "../app/database"
    nullable = false
}

variable "backend_image" {
    description = "Docker image for backend service"
    type = string
    default = "backend:latest"
    nullable = false
}

variable "backend_image_path" {
    description = "Path to Dockerfile for backend service"
    type = string
    default = "../app/backend"
    nullable = false
}

variable "frontend_image" {
    description = "Docker image for frontend service"
    type = string
    default = "frontend:latest"
    nullable = false
}

variable "frontend_image_path" {
    description = "Path to Dockerfile for frontend service"
    type = string
    default = "../app/frontend"
    nullable = false
}

variable "image_tag" {
    description = "Tag for Docker images"
    type = string
    default = ":latest"
    nullable = false
}

variable "image_pull_policy" {
    description = "Image pull policy for Kubernetes deployments"
    type = string
    default = "IfNotPresent"
    nullable = false
}

# Database configuration variables

variable "postgres_db_password" {
    description = "Password for PostgreSQL database"
    type = string
    sensitive = true
    nullable = false
}

variable "postgres_db_user" {
    description = "Username for PostgreSQL database"
    type = string
    nullable = false
}

variable "postgres_db_name" {
    description = "Database name for PostgreSQL"
    type = string
    nullable = false
}

variable "postgres_db_port" {
    description = "Port for PostgreSQL database"
    type = number
    default = 5432
    nullable = false
}

variable "postgres_db_host" {
    description = "Host for PostgreSQL database"
    type = string
    default = "localhost"
    nullable = false
}

variable "database_replicas" {
    description = "Number of replicas for database service"
    type = number
    default = 1
    nullable = false
}


# Backend configuration variables

variable "backend_port" {
    description = "Port for backend service"
    type = number
    default = 8000
    nullable = false
}
variable "backend_replicas" {
    description = "Number of replicas for backend service"
    type = number
    default = 2
    nullable = false
}

variable "backend_django_debug" {
    description = "Django debug mode for backend service"
    type = string
    default = "False"
    nullable = false
}

variable "backend_django_settings_module" {
    description = "Django settings module for backend service"
    type = string
    default = "app.settings"
    nullable = false
}


# Frontend configuration variables

variable "frontend_port" {
    description = "Port for frontend service"
    type = number
    default = 80
    nullable = false
}
variable "frontend_replicas" {
    description = "Number of replicas for frontend service"
    type = number
    default = 2
    nullable = false
}