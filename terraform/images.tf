locals {
  database_files = fileset("${path.module}/${var.database_image_path}", "**")

  database_hash = sha256(
    join("", [
      for f in local.database_files :
      filesha256("${path.module}/${var.database_image_path}/${f}")
    ])
  )

  backend_files = fileset("${path.module}/${var.backend_image_path}", "**")
  backend_hash = sha256(
    join("", [
      for f in local.backend_files :
      filesha256("${path.module}/${var.backend_image_path}/${f}")
    ])
  )

  frontend_files = fileset("${path.module}/${var.frontend_image_path}", "**")
  frontend_hash = sha256(
    join("", [
      for f in local.frontend_files :
      filesha256("${path.module}/${var.frontend_image_path}/${f}")
    ])
  )
}


resource "null_resource" "main_images" {
  triggers = {
    database = local.database_hash
    backend  = local.backend_hash
    frontend = local.frontend_hash
  }

  provisioner "local-exec" {
    command = <<EOT
        eval $(minikube docker-env -p lhub-learning-hub)
            docker build -f ${var.database_image_path}/Dockerfile -t ${var.database_image}${var.image_tag} ${var.database_image_path}
            docker build -f ${var.backend_image_path}/Dockerfile  -t ${var.backend_image}${var.image_tag}  ${var.backend_image_path}
            docker build -f ${var.frontend_image_path}/Dockerfile -t ${var.frontend_image}${var.image_tag} ${var.frontend_image_path}
            docker images | grep "${var.database_image}\|${var.backend_image}\|${var.frontend_image}"
        EOT
  }
}
