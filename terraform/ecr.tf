resource "aws_ecr_repository" "ui" {
  name                 = "retail-store-ui"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "retail-store-ui"
  }
}

resource "aws_ecr_repository" "catalog" {
  name                 = "retail-store-catalog"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "retail-store-catalog"
  }
}

resource "aws_ecr_repository" "cart" {
  name                 = "retail-store-cart"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "retail-store-cart"
  }
}

resource "aws_ecr_repository" "orders" {
  name                 = "retail-store-orders"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "retail-store-orders"
  }
}

resource "aws_ecr_repository" "checkout" {
  name                 = "retail-store-checkout"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "retail-store-checkout"
  }
}