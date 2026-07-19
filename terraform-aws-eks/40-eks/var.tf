variable "project_name" {
    default = "expense-dev"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense-dev"
        Environment = "dev"
        Terraform = "true"
    }
}