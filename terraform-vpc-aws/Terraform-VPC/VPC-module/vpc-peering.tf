resource "aws_vpc_peering_connection" "main" {
    count = var.is_peering_enabled ? 1 : 0
    # peer_owner_id = data.aws_caller_identity.current.account_id
    peer_vpc_id = local.default_vpc_id
    vpc_id = aws_vpc.main.id
    auto_accept = true

    tags = merge(
        var.common_tags,
        var.vpc_peering_tags,
        {
        "Name" = "${local.resource_name}-default"
        }
    )
  
}

# resource "aws_route" "public_perring" {
#     count = var.is_peering_enabled ? 1 : 0
#     route_table_id              = aws_route_table.public.id
#     vpc_peering_connection_id   = aws_vpc_peering_connection.default[count.index].id
#     destination_cidr_block      = local.default.vpc_cidr
# }

resource "aws_route" "public_peering" {
    count = var.is_peering_enabled ? 1 : 0
    route_table_id = aws_route_table.public.id
    destination_cidr_block = local.default_cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}

resource "aws_route" "private_peering" {
    count = var.is_peering_enabled ? 1 : 0
    route_table_id = aws_route_table.private.id
    destination_cidr_block = local.default_cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}

resource "aws_route" "database_peering" {
    count = var.is_peering_enabled ? 1 : 0
    route_table_id = aws_route_table.database.id
    destination_cidr_block = local.default_cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
} 

resource "aws_route" "default_peering" {
    count = var.is_peering_enabled ? 1 : 0
    route_table_id = data.aws_route_table.main.route_table_id
    destination_cidr_block = var.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
} 