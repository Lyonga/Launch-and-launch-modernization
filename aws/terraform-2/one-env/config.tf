resource "aws_iam_service_linked_role" "aws_config" {
  aws_service_name = "config.amazonaws.com"
}

resource "aws_config_configuration_recorder" "demo_recorder" {
  name     = "demo-recorder"
  role_arn = aws_iam_service_linked_role.aws_config.arn
}

resource "aws_config_delivery_channel" "demo_delivery_channel" {
  name           = "demo"
  s3_bucket_name = aws_s3_bucket.config_bucket.bucket
  sns_topic_arn = aws_sns_topic.config_topic.arn # optional
  depends_on     = [aws_config_configuration_recorder.demo_recorder]
}

resource "aws_config_configuration_recorder_status" "demo_recorder_status" {
  name       = aws_config_configuration_recorder.demo_recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.demo_delivery_channel]
}

resource "aws_config_config_rule" "vpc_default_security_group_closed" {
  name = "vpc-default-security-group-closed"
  source {
    owner             = "AWS"
    source_identifier = "VPC_DEFAULT_SECURITY_GROUP_CLOSED"
  }
  scope {
    compliance_resource_types = ["AWS::EC2::SecurityGroup"]
  }
}

resource "aws_config_config_rule" "s3_bucket_public_read_prohibited" {
  name                        = "s3-bucket-public-read-prohibited"
  maximum_execution_frequency = "TwentyFour_Hours"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }
  scope {
    compliance_resource_types = ["AWS::S3::Bucket"]
  }
}

//SNS

resource "aws_sns_topic" "config_topic" {
  name = "aws-config-notifications"
}

resource "aws_iam_role" "sns_publish_role" {
  name = "sns-publish-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "config.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role_policy" "sns_publish_policy" {
  role   = aws_iam_role.sns_publish_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "sns:Publish"
        ],
        Effect = "Allow",
        Resource = aws_sns_topic.config_topic.arn,
      },
    ],
  })
}

resource "aws_sns_topic_subscription" "config_subscription" {
  topic_arn = aws_sns_topic.config_topic.arn
  protocol  = "email"  # Can be "email", "sms", "lambda", etc.
  endpoint  = "c.lyonga03@yahoo.com"
}

//S3
resource "aws_s3_bucket" "config_bucket" {
  bucket = "config-bucket-for-my-config-channel-101"

  tags = {
    Name = "config_bucket"
  }

}

resource "aws_s3_bucket_policy" "config_bucket_policy" {
  bucket = aws_s3_bucket.config_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetBucketAcl",
          "s3:GetBucketPolicy"
        ],
        Effect = "Allow",
        Resource = aws_s3_bucket.config_bucket.arn,
        Principal = {
          Service = "config.amazonaws.com"
        },
      },
      {
        Action = [
          "s3:PutObject"
        ],
        Effect = "Allow",
        Resource = "${aws_s3_bucket.config_bucket.arn}/*",
        Principal = {
          Service = "config.amazonaws.com"
        },
      }
    ],
  })
}

//test clean up
