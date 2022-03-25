
locals {
  prefix   = var.prefix
  pgp_key  = var.pgp_key
  username = format("%s-vault-auto-unseal", local.prefix)
}

resource "aws_iam_user" "vault" {
  name = local.username
}

resource "aws_iam_access_key" "vault" {
  user    = aws_iam_user.vault.name
  pgp_key = local.pgp_key
}

resource "aws_iam_user_policy" "vault_kms_auto_unseal" {
  name = format("%s-vault-kms-auto-unseal", local.prefix)
  user = aws_iam_user.vault.name

  policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:DescribeKey",
            "kms:ReEncryptTo"
          ],
          "Effect": "Allow",
          "Resource": "${aws_kms_key.vault.arn}"
        }
      ]
    }
    EOF
}

output "aws_access_key_id" {
  value = aws_iam_access_key.vault.id
}

output "aws_secret_access_key" {
  value = aws_iam_access_key.vault.encrypted_secret
}
