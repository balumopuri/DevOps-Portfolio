# terraform-vpc-aws

Create the VPC first and later create the subnets for Public,Private and Database.

Steps to write the in the VPC module
====================================================
1. aws_vpc
2. aws_internet_gateway       → attach to VPC
3. aws_subnet (public-1a)     → public, AZ-1a
4. aws_subnet (public-1b)     → public, AZ-1b
5. aws_subnet (private-1a)    → private, AZ-1a
6. aws_subnet (private-1b)    → private, AZ-1b
7. aws_subnet (db-1a)         → database, AZ-1a
8. aws_subnet (db-1b)         → database, AZ-1b
9. aws_eip                    → elastic IP for NAT
10. aws_nat_gateway           → uses EIP, placed in public subnet
11. aws_route_table (public)  → route 0.0.0.0/0 → IGW
12. aws_route_table (private) → route 0.0.0.0/0 → NAT
13. aws_route_table (db)      → local only, no internet
14. aws_route_table_association × 6  → link each subnet to its RT


Variables which required for module.
====================================================
project_name    → used in naming all resources  e.g. "expense"
environment     → dev / prod                    e.g. "dev"
vpc_cidr        → VPC IP range                  e.g. "10.0.0.0/16"

public_subnet_cidrs   → list of 2 CIDRs   e.g. ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs  → list of 2 CIDRs   e.g. ["10.0.11.0/24", "10.0.12.0/24"]
db_subnet_cidrs       → list of 2 CIDRs   e.g. ["10.0.21.0/24", "10.0.22.0/24"]

azs             → list of 2 AZ names      e.g. ["ap-south-1a", "ap-south-1b"]


Output which expose
====================================================
vpc_id              → needed by security groups, EKS, RDS
public_subnet_ids   → needed by ALB, NAT gateway
private_subnet_ids  → needed by EC2 app servers, EKS nodes
db_subnet_ids       → needed by RDS, DB subnet group

