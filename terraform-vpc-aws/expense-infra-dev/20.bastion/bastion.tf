resource "aws_instance" "bastion" {
    ami = var.ami_id
    vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
    instance_type = "t3.micro"
    subnet_id = local.public_subnet_ids
    tags = merge(
        var.common_tags,
        { 
            Name = "${var.project_name}-${var.environment}-bastion" 
        }
    )
}