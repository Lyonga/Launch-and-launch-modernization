resource "aws_secretsmanager_secret" "username" {
  name = "username"
}

resource "aws_secretsmanager_secret_version" "username_secret" {
  secret_id     = aws_secretsmanager_secret.username.id
  secret_string = "test"
}

resource "aws_secretsmanager_secret" "password" {
  name = "password"
}

resource "aws_secretsmanager_secret_version" "password_secret" {
  secret_id     = aws_secretsmanager_secret.password.id
  secret_string = "test"
}
