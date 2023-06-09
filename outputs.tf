output "db_admin_secret_id" {
  value       = ""
  description = "string ||| The ID of the secret in AWS Secrets Manager containing the auth token"
}

output "db_protocol" {
  value       = local.auth_token_enabled ? "rediss" : "redis"
  description = "string ||| This emits `rediss` (secure) or `redis` and is used for generalized data store contracts."
}

output "db_endpoint" {
  value       = "${local.address}:${local.port}"
  description = "string ||| The endpoint URL to access Redis."
}

output "db_security_group_id" {
  value       = var.security_group_id
  description = "string ||| The ID of the security group attached to Elasticache cluster."
}
