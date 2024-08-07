resource "aws_vpc" "custom_vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc_tag_name}-${var.environment}"
  }
}

resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.0.0/18"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"

  tags = {
    Name = "${var.private_subnet_tag_name}-${var.environment}"
  }
}


resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.64.0/18"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"

  tags = {
    Name = "${var.private_subnet_tag_name}-${var.environment}"
  }
}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.128.0/18"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "${var.private_subnet_tag_name}-${var.environment}"
  }
}
resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "0.0.192.0/18"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    Name = "${var.private_subnet_tag_name}-${var.environment}"
  }
}

resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.custom_vpc.id
  #subnet_id     = var.public_subnet_ids[0]
  tags = {
    Name = "Main-Internet-Gateway"
  }
}

# resource "aws_internet_gateway" "IG2" {
#   vpc_id = aws_vpc.custom_vpc.id
#   #subnet_id     = var.public_subnet_ids[1]
#   tags = {
#     Name = "Main-Internet-Gateway"
#   }
# }


resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }
}


resource "aws_route_table_association" "RTA1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.RT.id
}


resource "aws_route_table_association" "RTA2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.RT.id
}

### Security Group Setup

# ALB Security group (If you want to use ALB instead of NLB. NLB doesn't use Security Groups)
resource "aws_security_group" "lb" {
  name        = "${var.security_group_lb_name}-${var.environment}"
  description = var.security_group_lb_description
  vpc_id      = "${aws_vpc.custom_vpc.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Traffic to the ECS Cluster should only come from the ALB
# or AWS services through an AWS PrivateLink
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.security_group_ecs_tasks_name}-${var.environment}"
  description = var.security_group_ecs_tasks_description
  vpc_id      = "${aws_vpc.custom_vpc.id}"

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = [
      aws_vpc_endpoint.s3.prefix_list_id
    ]
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Route table and subnet associations
resource "aws_route_table_association" "subnet_route_assoc" {
  count = var.number_of_private_subnets
  subnet_id      = aws_subnet.private1[count.index].id
  route_table_id = aws_vpc.custom_vpc.default_route_table_id
}