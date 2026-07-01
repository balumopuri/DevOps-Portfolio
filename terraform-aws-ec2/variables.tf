# default
variable "ami_id" {
    default = "ami-09c813fb71547fc4f"
}

# mandatory
variable "sg_id" {

}

variable "instance_type" {
    default = "t3.micro"
    validation {
        condition     = contains(["t3.micro", "t3.small", "t3.medium"], var.instance_type)
        error_message = "Valid values for instance type are: t3.small t3.medium t3.micro"
    } 
}

# optional
variable "tags" {
    default = {}
}