resource "aws_secretsmanager_secret" "amplifier-secret" "{
  name = "username"
}

resource "aws_secretsmanager_secret_version" "amplifier-secret-version" {
  secret_id     = aws_secretsmanager_secret.amplifier-secret.id
  secret_string = "test"
}

resource "aws_secretsmanager_secret" "amplifier" {
  name = "password"
}

resource "aws_secretsmanager_secret_version" "password_secret" {
  secret_id     = aws_secretsmanager_secret.amplifier.id
  secret_string = "test"
}