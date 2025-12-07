resource "aws_iam_role" "k8s_node_role" {
  name = "k8s-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# 2. Attach Policies (Storage & Image Pulling)
resource "aws_iam_role_policy_attachment" "ebs_csi_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.k8s_node_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.k8s_node_role.name
}

# 3. Create the Instance Profile (This links the Role to the EC2)
resource "aws_iam_instance_profile" "k8s_node_profile" {
  name = "k8s-node-profile"
  role = aws_iam_role.k8s_node_role.name
}