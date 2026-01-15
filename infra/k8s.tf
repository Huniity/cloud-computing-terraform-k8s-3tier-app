# resource "minikube_cluster" "mycluster" {
#     cluster_name = var.client
#     nodes = 1
# }
# resource "kubernetes_namespace_v1" "app" {
#     metadata {
#         name = "app-${var.client}"
#     }
# }