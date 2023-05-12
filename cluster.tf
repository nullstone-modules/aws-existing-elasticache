data "aws_elasticache_cluster" "this" {
  cluster_id = var.cluster_id
}

data "aws_elasticache_replication_group" "this" {
  replication_group_id = data.aws_elasticache_cluster.this.replication_group_id
}

locals {
  security_group_ids = data.aws_elasticache_cluster.this.security_group_ids
  auth_token_enabled = data.aws_elasticache_replication_group.this.auth_token_enabled
}


data "validation_error" "security_group_id" {
  condition = contains(local.security_group_ids, var.security_group_id)
  summary   = "The specified var.security_group_id is not attached to the Elasticache cluster."
  details   = <<EOF
The security group is used to open network access to the Elasticache cluster.
The security group must already be attached to the Elasticache cluster.
EOF
}
