# Get latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# Control-plane instance
resource "aws_instance" "control_plane" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.control_plane.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.k8s_node_profile.name 

  tags = {
    Name = "k8s-control-plane"
    Role = "control-plane"
  }
}

# Worker 1
resource "aws_instance" "worker1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[1].id
  vpc_security_group_ids      = [aws_security_group.worker.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.k8s_node_profile.name 
  
  root_block_device {
    volume_size = 20    
    volume_type = "gp3" 
  }

  tags = {
    Name = "k8s-worker-1"
    Role = "worker"
  }
}

# Worker 2
resource "aws_instance" "worker2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[2].id
  vpc_security_group_ids      = [aws_security_group.worker.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.k8s_node_profile.name 

  root_block_device {
    volume_size = 20    
    volume_type = "gp3" 
  }

  tags = {
    Name = "k8s-worker-2"
    Role = "worker"
  }
}

