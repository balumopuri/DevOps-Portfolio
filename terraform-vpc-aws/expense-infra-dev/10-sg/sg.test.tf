module "mysql_sg" {
    source = "git::https://github.com/balumopuriDSO/terraform-vpc-aws.git//Terraform-aws-securitygroup/aws-sg-module?ref=61edddd9ffecf2a07c59bff5c1e5fba1e8f0832b"
    project_name = var.project_name
    environment = var.environment
    sg_name = "mysql"
    sg_description = var.sg_description
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}


module "backend_sg" {
    source = "git::https://github.com/balumopuriDSO/terraform-vpc-aws.git//Terraform-aws-securitygroup/aws-sg-module?ref=61edddd9ffecf2a07c59bff5c1e5fba1e8f0832b"
    project_name = var.project_name
    environment = var.environment
    sg_name = "backend"
    sg_description = "created for backend instances in expense dev"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "frontend_sg" {
    source = "git::https://github.com/balumopuriDSO/terraform-vpc-aws.git//Terraform-aws-securitygroup/aws-sg-module?ref=61edddd9ffecf2a07c59bff5c1e5fba1e8f0832b"
    project_name = var.project_name
    environment = var.environment
    sg_name = "frontend"
    sg_description = "created for frontend instances in expense dev"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "bastion_sg" {
    source = "git::https://github.com/balumopuriDSO/terraform-vpc-aws.git//Terraform-aws-securitygroup/aws-sg-module?ref=61edddd9ffecf2a07c59bff5c1e5fba1e8f0832b"
    project_name = var.project_name
    environment = var.environment
    sg_name = "bastion"
    sg_description = "created for bastion instances in expense dev"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "app_alb_sg" {
    source = "git::https://github.com/balumopuriDSO/terraform-vpc-aws.git//Terraform-aws-securitygroup/aws-sg-module?ref=61edddd9ffecf2a07c59bff5c1e5fba1e8f0832b"
    project_name = var.project_name
    environment = var.environment
    sg_name = "app-alb"
    sg_description = "created for backend alb in expense dev"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}


module "vpn_sg" {
    source = "git::https://github.com/balumopuriDSO/terraform-vpc-aws.git//Terraform-aws-securitygroup/aws-sg-module?ref=61edddd9ffecf2a07c59bff5c1e5fba1e8f0832b"
    project_name = var.project_name
    environment = var.environment
    sg_name = "vpn"
    sg_description = "created for VPN in expense dev"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

# A
resource "aws_security_group_rule" "app_alb_bastion" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    source_security_group_id = module.bastion_sg.sg_id
    security_group_id = module.app_alb_sg.sg_id
  
}

resource "aws_security_group_rule" "bastion_public" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.bastion_sg.sg_id
  
}

resource "aws_security_group_rule" "vpn_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.vpn_sg.sg_id
  
}

resource "aws_security_group_rule" "vpn_443" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.vpn_sg.sg_id
  
}

resource "aws_security_group_rule" "vpn_943" {
    type = "ingress"
    from_port = 943
    to_port = 943
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.vpn_sg.sg_id
  
}

resource "aws_security_group_rule" "vpn_1194"{
    type = "ingress"
    from_port = 1194
    to_port = 1194
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.vpn_sg.sg_id
}


resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.app_alb_sg.sg_id
}

resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}

resource "aws_security_group_rule" "mysql_vpn" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}



resource "aws_security_group_rule" "backend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.backend_sg.sg_id
}

resource "aws_security_group_rule" "backend_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.backend_sg.sg_id
}

resource "aws_security_group_rule" "backend_app_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.sg_id
  security_group_id = module.backend_sg.sg_id
}

resource "aws_security_group_rule" "mysql_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}

resource "aws_security_group_rule" "web_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.web_alb_sg.sg_id
}

resource "aws_security_group_rule" "app_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend_sg.sg_id
  security_group_id = module.app_alb_sg.sg_id
}

resource "aws_security_group_rule" "frontend_web_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_alb_sg.sg_id
  security_group_id = module.frontend_sg.sg_id
}

# usually you should configure frontend using private ip from VPN only
resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.frontend_sg.sg_id
}

module "web_alb_sg" {
    source = "git::https://github.com/balumopuriDSO/terraform-vpc-aws.git//Terraform-aws-securitygroup/aws-sg-module?ref=61edddd9ffecf2a07c59bff5c1e5fba1e8f0832b"
    project_name    = var.project_name
    environment     = var.environment
    sg_name         = "web-alb"
    sg_description  = "created for web ALB in expense dev"
    vpc_id          = data.aws_ssm_parameter.vpc_id.value
}