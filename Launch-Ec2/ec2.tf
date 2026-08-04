resource "aws_instance" "this" {
  ami                    = "ami-0220d79f3f480ecf5" # DevOps Practice AMI
  instance_type          = "t3.medium"
  vpc_security_group_ids = [aws_security_group.allow_all_docker.id]

  user_data = file("jenkins.sh")

  # Increase root volume size
  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  tags = {
    Name = "Jenkins-Server"
  }
}

resource "aws_security_group" "allow_all_docker" {
  name        = "allow_all_docker-all"
  description = "Allow Jenkins and SSH access"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Jenkins
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_jenkins"
  }
}

output "jenkins_ip" {
  value = aws_instance.this.public_ip
}