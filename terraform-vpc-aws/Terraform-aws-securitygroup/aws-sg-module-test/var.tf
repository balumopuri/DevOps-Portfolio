variable "common_tags"{
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true" 
    }
}

variable "project_name"{
    default = "expense"
}

variable "sg_name" {
    default = "mysql"
}

variable "environment"{
    default = "dev"
}


variable "sg_description" {
    default = "created for MYSQL instances in expense dev"
}
