variable "common_tags"{
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true" 
    }
}

variable "project_name"{
    default = "expense-dev"
}

variable "sg_name" {
    default = ["mysql,backend,front"]
}

variable "environment"{
    default = "dev"
}


variable "sg_description" {
    default = "created for mysql instances in expense dev"
}
