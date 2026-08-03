resource "aws_instance" "this" {
  ami                    = "ami-0220d79f3f480ecf5" # This is our devops-practice AMI ID
  vpc_security_group_ids = [aws_security_group.allow_all_docker.id]
  instance_type          = "t3.medium"

  user_data = file("jenkins.sh")
  tags = {
    Name    = "Jenkins"
  }
}

resource "aws_security_group" "allow_all_docker" {
  name        = "allow_all_docker"
  description = "Allow TLS inbound traffic and all outbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
output "jenkins_ip" {
  value       = aws_instance.this.public_ip
}