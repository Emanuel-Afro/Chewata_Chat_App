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
    Env = var.Chewata_Enviroment
  }
}

resource "aws_subnet" "Chewata_Public_Subnet" {
  vpc_id = aws_vpc.Chewata_VPC.id
  cidr_block = var.chewata_cidr_block
  availability_zone = var.Chewata_Public_Subnet_AZ
  tags = {
    name = "Chewata_Public_Subnet"
    Env = var.Chewata_Enviroment
  }
}

resource "aws_subnet" "Chewata_Private_Subnet" {
  vpc_id = aws_vpc.Chewata_VPC.id
  cidr_block = var.chewata_cidr_block
  availability_zone = var.Chewata_Private_Subnet_AZ
  tags = {
    name = "Chewata_Private_Subnet"
    Env = var.Chewata_Enviroment 
  }
}

