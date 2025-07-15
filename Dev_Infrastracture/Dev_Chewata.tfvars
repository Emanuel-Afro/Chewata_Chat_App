Chewata_ALB_FE = {
  ALB_1 = {
    FE_name_ALB        = "ChewataAlbFE"
    FE_name_TG         = "ChewataALBTargetGroupFE"
    protocol           = "HTTPS"
    port               = 443
    load_balancer_type = "application"
  }
}
# Chewata_Front_end_EC2 = {
#   Dev_EC2_1 = "Dev_EC2_1"
#   Dev_EC2_2 = "Dev_EC2_2"
#   ami = "ami-0b6d52d4a526e3ec3"
# }

Chewata_Front_End_HC = {
  path                = "/heath"
  protocol            = "HTTP"
  matcher             = 200
  interval            = 30
  timeout             = 7
  healthy_threshold   = 3
  unhealthy_threshold = 5
}

Chewata_ASG_FE = {
  ASG = {
    name             = "Chewata_Auto_Scaling_Group"
    min              = 2
    max              = 5
    desired_capacity = 2
    EC2_name         = "Chewata-Dev-EC2"
    image_id         = "ami-0b6d52d4a526e3ec3"
    instance_type    = "t2.micro"
    grace_period     = 3000

  }
}