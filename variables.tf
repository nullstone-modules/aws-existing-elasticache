variable "cluster_id" {
  type        = string
  description = "The name of the existing Elasticache cluster."
}

variable "security_group_id" {
  type        = string
  description = "The security group attached to the Elasticache cluster."
}
