# -----------------------------------------------------------------------------
# KMS Key Ring Outputs
#
# These outputs expose the Key Ring information returned by the reusable
# module without requiring consumers to understand its internal resources.
# -----------------------------------------------------------------------------

output "key_ring_id" {
  description = "KMS Key Ring ID."
  value       = module.kms.key_ring_id
}

output "key_ring_name" {
  description = "KMS Key Ring name."
  value       = module.kms.key_ring_name
}

# -----------------------------------------------------------------------------
# KMS Crypto Key Outputs
#
# The caller creates a logical key named "main" in the reusable module's key
# map. These outputs hide that implementation detail and expose a simple
# Crypto Key ID and name to downstream consumers.
#
# crypto_key_id is especially useful for services that need to reference a
# customer-managed encryption key.
# -----------------------------------------------------------------------------

output "crypto_key_id" {
  description = "KMS Crypto Key ID."
  value       = module.kms.crypto_key_ids["main"]
}

output "crypto_key_name" {
  description = "KMS Crypto Key name."
  value       = module.kms.crypto_key_names["main"]
}
