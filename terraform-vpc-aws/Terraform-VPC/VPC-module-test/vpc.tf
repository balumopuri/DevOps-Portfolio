module "vpc" {
    source = "../VPC module"
    # source = "git::VPC module?ref=main"
    project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    cidr_block = var.cidr_block
    # igw_tags = var.igw_tags
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    database_subnet_cidrs = var.database_subnet_cidrs
    is_peering_enabled = true
}