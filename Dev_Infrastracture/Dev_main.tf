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

resource "aws_security_group_rule" "Chewata_Front_End_Sg_Rule" { //Think about defining different security group for EC2!!
  for_each          = var.Chewata_front_end_sg
  type              = "ingress"
  from_port         = each.value.from_port-1
  to_port           = each.value.to_port-1
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

resource "aws_security_group_rule" "Chewata_Back_End_Sg_Rule" { //Think about defining different security group for EC2!!
  for_each                 = var.Chewata_back_end_sg
  type                     = "ingress"
  from_port                = each.value.from_port-2
  to_port                  = each.value.to_port-2
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
  for_each                 = var.Chewata_mongo_sg
  type                     = "ingress"
  from_port                = each.value.from_port-3
  to_port                  = each.value.from_port-3
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
# resource "aws_instance" "Chewata_EC2_Front-End" {
#   for_each = var.Chewata_Front_end_EC2
#     ami = var.Chewata_Front_end_EC2.ami  # -----Fix this with urgent tomorrow morning!!! It is showing wrong AMI!!!!
#   instance_type = "t2.micro"
#   subnet_id = aws_subnet.Chewata_Public_Subnet.id

// security_groups = [aws_security_group_rule.Chewata_Front_End_Sg_Rule.id]

#Application-Load Balancer For Front-End

resource "aws_alb" "Chewata_ALB_FE" {
  for_each           = var.Chewata_ALB_FE
  name               = each.value.FE_name_ALB
  internal           = false
  load_balancer_type = each.value.load_balancer_type
  security_groups    = [aws_security_group.Chewata_sg_Front_End.id]
  subnets            = [aws_subnet.Chewata_Public_Subnet.id]
}

#=========Front-End============

# ALB target group

resource "aws_lb_target_group" "Chewata_ALB_target_group" {
  for_each = var.Chewata_ALB_FE
  name     = each.value.FE_name_TG
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = aws_vpc.Chewata_VPC.id

  health_check {
    path                = var.Chewata_Front_End_HC.path                # ALB will check the /health path for continuous testing
    protocol            = var.Chewata_Front_End_HC.protocol            # The protocol used for the test
    matcher             = var.Chewata_Front_End_HC.matcher             #Expected resust of the check
    interval            = var.Chewata_Front_End_HC.interval            # Time difference to do the tests every ...
    timeout             = var.Chewata_Front_End_HC.timeout             # Waiting time before TimeOut
    healthy_threshold   = var.Chewata_Front_End_HC.healthy_threshold   # Number of success will mark it healthy
    unhealthy_threshold = var.Chewata_Front_End_HC.unhealthy_threshold # Number of failures will mark it failed
  }
}

#ALB Listener
resource "aws_alb_listener" "Chewata_ALB_FE_Listener" {
  for_each          = var.Chewata_ALB_FE
  load_balancer_arn = aws_alb.Chewata_ALB_FE[each.key].arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Chewata_ALB_target_group[each.key].arn

  }
}

# Auto Scaling Group for Front-End
resource "aws_autoscaling_group" "Chewata_ASG_FE" {
  for_each                  = var.Chewata_ASG_FE
  name                      = each.value.name
  min_size                  = each.value.min
  max_size                  = each.value.max
  desired_capacity          = each.value.desired_capacity
  vpc_zone_identifier       = [aws_subnet.Chewata_Public_Subnet.id]
  launch_configuration      = aws_launch_configuration.Chewata_EC2_FE_config[each.key].id
  target_group_arns         = [aws_lb_target_group.Chewata_ALB_target_group["ALB_FE"].arn]
  health_check_type         = "ALB"
  health_check_grace_period = each.value.grace_period
}

resource "random_id" "frontend_instance_id" {
  byte_length = 4 # Generates 8-character hex 
}

resource "aws_launch_configuration" "Chewata_EC2_FE_config" {
  for_each             = var.Chewata_ASG_FE
  name                 = "var.EC2_name-${random_id.frontend_instance_id.hex}"
  image_id             = each.value.image_id
  instance_type        = each.value.instance_type
  user_data            = file("/start_up_FE.sh")
  security_groups      = [aws_security_group.Chewata_sg_Front_End.id]
  iam_instance_profile = aws_iam_instance_profile.chewata_cloudwatch_profile.name

  lifecycle {
    create_before_destroy = true
  }
}


#==========Back-End========================

resource "aws_alb" "Chewata_ALB_BE" {
  for_each           = var.Chewata_ALB_BE
  name               = each.value.BE_name_ALB
  internal           = true
  load_balancer_type = each.value.load_balancer_type
  security_groups    = [aws_security_group.Chewata_sg_Back_End.id]
  subnets            = [aws_subnet.Chewata_Private_Subnet.id]
}

# ALB target group

resource "aws_lb_target_group" "Chewata_ALB_target_group_BE" {
  for_each = var.Chewata_ALB_BE
  name     = each.value.BE_name_TG
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = aws_vpc.Chewata_VPC.id

  health_check {
    path                = var.Chewata_Back_End_HC.path                # ALB will check the /health path for continuous testing
    protocol            = var.Chewata_Back_End_HC.protocol            # The protocol used for the test
    matcher             = var.Chewata_Back_End_HC.matcher             #Expected resust of the check
    interval            = var.Chewata_Back_End_HC.interval            # Time difference to do the tests every ...
    timeout             = var.Chewata_Back_End_HC.timeout             # Waiting time before TimeOut
    healthy_threshold   = var.Chewata_Back_End_HC.healthy_threshold   # Number of success will mark it healthy
    unhealthy_threshold = var.Chewata_Back_End_HC.unhealthy_threshold # Number of failures will mark it failed
  }
}

#ALB Listener
resource "aws_alb_listener" "Chewata_ALB_BE_Listener" {
  for_each          = var.Chewata_ALB_BE
  load_balancer_arn = aws_alb.Chewata_ALB_BE[each.key].arn
  port              = 443
  protocol          = each.value.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Chewata_ALB_target_group_BE[each.key].arn

  }
}

# Auto Scaling Group for Back-End
resource "aws_autoscaling_group" "Chewata_ASG_BE" {
  for_each                  = var.Chewata_ASG_BE
  name                      = each.value.name
  min_size                  = each.value.min
  max_size                  = each.value.max
  desired_capacity          = each.value.desired_capacity
  vpc_zone_identifier       = [aws_subnet.Chewata_Private_Subnet.id]
  launch_configuration      = aws_launch_configuration.Chewata_EC2_BE_config[each.key].id
  target_group_arns         = [aws_lb_target_group.Chewata_ALB_target_group_BE["ALB_BE"].arn]
  health_check_type         = "ALB"
  health_check_grace_period = each.value.grace_period
}

resource "random_id" "backend_instance_id" {
  byte_length = 4 # Generates 8-character hex 
}

resource "aws_launch_configuration" "Chewata_EC2_BE_config" {
  for_each             = var.Chewata_ASG_BE
  name                 = "var.EC2_name-${random_id.frontend_instance_id.hex}"
  image_id             = each.value.image_id
  instance_type        = each.value.instance_type
  user_data            = file("/start_up_BE.sh")
  security_groups      = [aws_security_group.Chewata_sg_Back_End.id]
  iam_instance_profile = aws_iam_instance_profile.chewata_cloudwatch_profile.name

  lifecycle {
    create_before_destroy = true
  }
}

#========Monitoring==============

resource "aws_cloudwatch_log_group" "Chewata_FE_Log" {
  name              = "/Chewata/App_FE"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "Chewata_BE_Log" {
  name              = "/Chewata/App_BE"
  retention_in_days = 30
}

#-------Create IAM Policy----------
resource "aws_iam_policy" "chewata_iam_policy" {
  name = "ChewataCloudWatchPolicy"
  policy = jsonencode({
    version = "2012-10-17"
    Statement = [
      {
        Action = [                # List of allowed log actions
          "logs:CreateLogGroup",  # Allows creating a log group
          "logs:CreateLogStream", # Allows creating a log stream within a group
          "logs:PutLogEvents"     # Allows pushing logs to the stream
        ],
        Effect   = "Allow", # Grant the above permissions
        Resource = ""       # Apply this policy to all log resources
      }
    ]
  })
}

#----------Creating IAM Role---------------
resource "aws_iam_role" "chewata_ec2_cloudwatch_role" {
  name = "chewata-ec2-cloudwatch-role"
  assume_role_policy = jsonencode({
    version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.awsamazon.com" # EC2 is allowed to assume this role
        },
        Action = "sts:AssumeRole" # Required action to assume the role
      }
    ]
  })
}

#--------------Attach the IAM Role with the policy---------------
resource "aws_iam_role_policy_attachment" "chewata_iam_policy_attachment" {
  role       = aws_iam_role.chewata_ec2_cloudwatch_role.name
  policy_arn = aws_iam_policy.chewata_iam_policy.arn
}

#-------------Create IAM profile-----------------
resource "aws_iam_instance_profile" "chewata_cloudwatch_profile" {
  name = "chewata-cloudwatch-profile"
  role = aws_iam_role.chewata_ec2_cloudwatch_role.name
}

#----------Alarm_ Monitoring-----------------
resource "aws_cloudwatch_metric_alarm" "chewata_fe_cpu_alarm" {
  for_each = var.Chewata_ASG_FE
  alarm_name          = "Chewata_Front-End High-CPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "CPUUtilization"
  namespace           = "AWS/AutoScaling"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Triggers if CPU Utilization exceeds 70% for 30 seconds"
  dimensions = {
    AutoScalingGroupName = each.value.name
}
}
resource "aws_cloudwatch_metric_alarm" "chewata_be_cpu_alarm" {
  for_each = var.Chewata_ASG_BE
  alarm_name          = "Chewata_Back-End High-CPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "CPUUtilization"
  namespace           = "AWS/AutoScaling"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Triggers if CPU Utilization exceeds 70% for 30 seconds"
  dimensions = {
    AutoScalingGroupName = each.value.name
  }
}

resource "aws_cloudwatch_metric_alarm" "chewata_fe_disk_alarm" {
  alarm_name          = "Chewata_Front-End High-Disk_Space"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "DiskUsedPercent"
  namespace           = "CWagent"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Triggers if Disk Utilization exceeds 70% for 30 seconds"
  dimensions = {
     path = "/"
    fstype = "xfs"
    //instance_id = [aws_launch_configuration.Chewata_EC2_BE_config.id]
  }
}

resource "aws_cloudwatch_metric_alarm" "chewata_be_disk_alarm" {
  alarm_name          = "Chewata_Back-End High-Disk_Space"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "DiskUsedPercent"
  namespace           = "CWagent"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Triggers if Disk Utilization exceeds 70% for 30 seconds"
  dimensions = {
    path = "/"
    fstype = "xfs"
    //instance_id = [aws_launch_configuration.Chewata_EC2_BE_config.id]
  }
}

