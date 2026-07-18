module "vpc" {
  source       = "git::https://github.com/balumopuri/terraform-vpc-aws.git//Terraform-VPC/VPC%20module?ref=main"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
  cidr_block   = var.cidr_block
  # igw_tags = var.igw_tags
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  is_peering_enabled    = true
}

# this can be included in module
resource "aws_db_subnet_group" "expense" {
  name       = "${var.project_name}-${var.environment}"
  subnet_ids = module.vpc.database_subnet_ids

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}"
    }
  )
}