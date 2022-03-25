variable "prefix" {
  type        = string
  description = "Prefix for all resources"
}

variable "pgp_key" {
  type        = string
  description = "Optional GPG/PGP key to encrypt the sercret access key"
  default     = null
}