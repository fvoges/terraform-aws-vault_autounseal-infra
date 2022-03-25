resource "aws_kms_key" "vault" {
  description             = format("Vault KMS auto-unseal key - %s", local.prefix)
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags = {
    "Name" = format("%s-vault", local.prefix)
  }
}

resource "aws_kms_alias" "vault" {
  name          = format("alias/%s-vault-autounseal", local.prefix)
  target_key_id = aws_kms_key.vault.key_id
}

output "kms_key_arn" {
  value = aws_kms_key.vault.arn
}

output "kms_key_id" {
  value = aws_kms_key.vault.id
}
