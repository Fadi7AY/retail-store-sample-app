output "control_plane_public_ip" {
  description = "Public IP of the Kubernetes control-plane node"
  value       = aws_instance.control_plane.public_ip
}

output "worker_public_ips" {
  description = "Public IPs of the Kubernetes worker nodes"
  value = [
    aws_instance.worker1.public_ip,
    aws_instance.worker2.public_ip
  ]
}

output "ecr_ui_url" {
  value       = aws_ecr_repository.ui.repository_url
  description = "ECR URL for UI service"
}

output "ecr_catalog_url" {
  value       = aws_ecr_repository.catalog.repository_url
  description = "ECR URL for Catalog service"
}

output "ecr_cart_url" {
  value       = aws_ecr_repository.cart.repository_url
  description = "ECR URL for Cart service"
}

output "ecr_orders_url" {
  value       = aws_ecr_repository.orders.repository_url
  description = "ECR URL for Orders service"
}

output "ecr_checkout_url" {
  value       = aws_ecr_repository.checkout.repository_url
  description = "ECR URL for Checkout service"
}