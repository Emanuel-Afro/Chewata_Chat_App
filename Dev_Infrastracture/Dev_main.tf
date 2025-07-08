terraform {
  required_providers {
    aws = {
      # source = "hashicop/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {

  access_key = "test"
  secret_key = "test"
  region     = "us-west-1"

  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {

    apigateway     = "http://localhost:4566"
    apigatewayv2   = "http://localhost:4566"
    autoscaling    = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    elb            = "http://localhost:4566"
    es             = "http://localhost:4566"
    elasticache    = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    logs           = "http://localhost:4566"
    rds            = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    route53        = "http://localhost:4566"
    s3             = "http://localhost:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
}

#+++++++++ Dev Enviroment++++++++++++++++++++++
resource "aws_vpc" "Chewata_VPC" {
  cidr_block = var.chewata_cidr_block
  tags = {
    name = "Chewata_VPC_Dev"
    Env  = var.Chewata_Enviroment
  }
}

resource "aws_subnet" "Chewata_Public_Subnet" {
  vpc_id            = aws_vpc.Chewata_VPC.id
  cidr_block        = var.chewata_cidr_block
  availability_zone = var.Chewata_Public_Subnet_AZ
  tags = {
    name = "Chewata_Public_Subnet"
    Env  = var.Chewata_Enviroment
  }
}

resource "aws_subnet" "Chewata_Private_Subnet" {
  vpc_id            = aws_vpc.Chewata_VPC.id
  cidr_block        = var.chewata_cidr_block
  availability_zone = var.Chewata_Private_Subnet_AZ
  tags = {
    name = "Chewata_Private_Subnet"
    Env  = var.Chewata_Enviroment
  }
}

resource "aws_internet_gateway" "Chewata_Internet_Getway" { # Outgoing and Incoming Traffic
  vpc_id = aws_vpc.Chewata_VPC.id
  tags = {
    name = "Chewata_Internet_Getway"
    Env  = var.Chewata_Enviroment
  }
}

resource "aws_route_table" "Chewata_Route_Table_Public" {
  vpc_id = aws_vpc.Chewata_VPC.id
  route {
    cidr_block = var.chewata_cidr_block
    gateway_id = aws_internet_gateway.Chewata_Internet_Getway.id
  }
}

resource "aws_route_table_association" "Chewata_Public_Route_Association" {
  subnet_id      = aws_subnet.Chewata_Public_Subnet.id
  route_table_id = aws_route_table.Chewata_Route_Table_Public.id
}

# Elastic NAT Gateway

resource "aws_eip" "Chewata_NAT_Ip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "Chewata_Nat_Gw" {
  allocation_id = aws_eip.Chewata_NAT_Ip.id
  subnet_id     = aws_subnet.Chewata_Public_Subnet.id
}

resource "aws_route_table" "Chewata_Route_Table_Private" {
  vpc_id = aws_vpc.Chewata_VPC.id
  route {
    cidr_block = var.chewata_cidr_block
    gateway_id = aws_internet_gateway.Chewata_Internet_Getway.id
  }
}

resource "aws_route_table_association" "Chewata_Private_Route_Association" {
  subnet_id      = aws_subnet.Chewata_Private_Subnet.id
  route_table_id = aws_route_table.Chewata_Route_Table_Private.id
}

resource "aws_security_group" "Chewata_sg_Front_End" {
  vpc_id = aws_vpc.Chewata_VPC.id

  # for_each = var.Chewata_front_end_sg
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "Chewata_Front_End_Sg_Rule" {
  for_each          = var.Chewata_front_end_sg
  type              = "ingress"
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  security_group_id = aws_security_group.Chewata_sg_Front_End.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "Chewata_sg_Back_End" {
  vpc_id = aws_vpc.Chewata_VPC.id
  #for_each = var.Chewata_back_end_sg
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "Chewata_Back_End_Sg_Rule" {
  for_each                 = var.Chewata_back_end_sg
  type                     = "ingress"
  from_port                = each.value
  to_port                  = each.value
  protocol                 = "tcp"
  security_group_id        = aws_security_group.Chewata_sg_Back_End.id
  source_security_group_id = aws_security_group.Chewata_sg_Front_End.id
  //cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group" "Chewata_MongoDB_sg" {
  vpc_id = aws_vpc.Chewata_VPC.id
  # for_each = var.Chewata_MongoDB_sg
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "Chewata_MongoDB_Sg_Rule" {
  for_each                 = var.Chewata_MongoDB_sg
  type                     = "ingress"
  from_port                = each.value
  to_port                  = each.value
  protocol                 = "tcp"
  security_group_id        = aws_security_group.Chewata_MongoDB_sg.id
  source_security_group_id = aws_security_group.Chewata_sg_Back_End.id
}

resource "aws_s3_bucket" "Chewata_S3_Bucket" {
  bucket        = "Chewata-Chat-App"
  force_destroy = false
  tags = {
    name = "Chewata S3 Bucket"
  }
}

#Block Public Access
resource "aws_s3_bucket_public_access_block" "Chewata_Block_Public_Access" {
  bucket                  = aws_s3_bucket.Chewata_S3_Bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Server-Side encription
resource "aws_s3_bucket_server_side_encryption_configuration" "Chewata_Server_Side_Encription" {
  bucket = aws_s3_bucket.Chewata_S3_Bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable versioning 
resource "aws_s3_bucket_versioning" "Chewata_s3_Versioning" {
  bucket = aws_s3_bucket.Chewata_S3_Bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Denay all traffic from HTTP

resource "aws_s3_bucket_policy" "Chewata_s3_policy" {
  bucket = aws_s3_bucket.Chewata_S3_Bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "DenyInsecureTransport",
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:*",
        Resource = [
          "${aws_s3_bucket.Chewata_S3_Bucket.arn}",
          "${aws_s3_bucket.Chewata_S3_Bucket.arn}/*"
        ],
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

# EC-2 Instance

resource "aws_instance" "Chewata_EC2_Front-End" {
  for_each = var.Chewata_Front_end_EC2
    ami = each.value    # -----Fix this with urgent tomorrow morning!!! It is showing wrong AMI!!!!
  instance_type = "t2.micro"
  subnet_id = aws_subnet.Chewata_Public_Subnet.id

 // security_groups = [aws_security_group_rule.Chewata_Front_End_Sg_Rule.id]
}

# Application-Load Balancer

# resource "aws_alb" "Chewata_ALB" {
#   # for_each           = var.Chewata_ALB
#   name               = var.Chewata_ALB.name_1
#   internal           = false
#   load_balancer_type = var.Chewata_ALB.load_balancer_type
#   security_groups    = [aws_security_group.Chewata_sg_Front_End.id]
#   subnets            = [aws_subnet.Chewata_Public_Subnet.id]
# }

# # ALB target group

# resource "aws_lb_target_group" "Chewata_ALB_target_group" {
#   # for_each = var.Chewata_ALB
#   name     = var.Chewata_ALB.name_2
#   port     = var.Chewata_ALB.port
#   protocol = var.Chewata_ALB.protocol
#   vpc_id   = aws_vpc.Chewata_VPC.id
# }

# #ALB Listener
