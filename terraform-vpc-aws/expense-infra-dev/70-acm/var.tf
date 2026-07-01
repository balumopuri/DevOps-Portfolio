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

variable "domain_name" {
    default = "balaportfolio.space"
  
}

variable "zone_id" {
    default = "Z1003784M55T6CSMP30H"
  
}