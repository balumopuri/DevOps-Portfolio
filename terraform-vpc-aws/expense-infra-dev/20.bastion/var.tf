variable "ami_id" {
    default = "ami-0220d79f3f480ecf5"
}

variable "instance_type" {
    default = "t3.micro"
}

variable "ec2_tags" {
    default = {
        Name  = "expense-app"
        Purpose =   "expense-app-dev"
    } 
}

variable "from_port" {
    default = 22
    }

variable "to_port" {
    default = "22"
}

variable "cidr_blocks" {
    default = ["0.0.0.0/0"]
}

variable "aws_region" {
    default = "us-east-1"
  
}

variable "project_name"{
    default = "expense-dev"
}

variable "environment" {
    default = "dev"
}

variable "common_tags"{
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true" 
    }
}