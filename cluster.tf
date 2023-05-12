data "aws_elasticache_cluster" "this" {
  cluster_id = var.cluster_id
}

data "aws_elasticache_replication_group" "this" {
  count                = local.has_replication_group ? 1 : 0
  replication_group_id = data.aws_elasticache_cluster.this.replication_group_id
}

locals {
  security_group_ids    = data.aws_elasticache_cluster.this.security_group_ids
  has_replication_group = length(data.aws_elasticache_cluster.this.replication_group_id) > 0

  auth_token_enabled  = try(data.aws_elasticache_replication_group.this[0].auth_token_enabled, false)
  replication_address = try(data.aws_elasticache_replication_group.this[0].primary_endpoint_address, "")
  replication_port    = try(data.aws_elasticache_replication_group.this[0].port, null)

  node_addrs = [for cn in data.aws_elasticache_cluster.this.cache_nodes : cn.address]
  node_ports = [for cn in data.aws_elasticache_cluster.this.cache_nodes : cn.port]
  node_addr  = try(local.node_addrs[0], "")
  node_port  = try(local.node_ports[0], 6379)

  address = coalesce(local.replication_address, local.node_addr)
  port    = coalesce(local.replication_port, local.node_port)
}

data "validation_error" "security_group_id" {
  condition = contains(local.security_group_ids, var.security_group_id)
  summary   = "The specified var.security_group_id is not attached to the Elasticache cluster."
  details   = <<EOF
The security group is used to open network access to the Elasticache cluster.
The security group must already be attached to the Elasticache cluster.
EOF
}
