resource "aws_secretsmanager_secret" "username_secret" {
  name = "username"
}

resource "aws_secretsmanager_secret_version" "username_secret" {
  secret_id     = aws_secretsmanager_secret.username_secret.id
  secret_string = ""
}

resource "aws_secretsmanager_secret" "password_secret" {
  name = "password"
}

resource "aws_secretsmanager_secret_version" "password_secret" {
  secret_id     = aws_secretsmanager_secret.password_secret.id
  secret_string = ""
}
