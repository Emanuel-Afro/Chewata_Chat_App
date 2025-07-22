Chewata_front_end_sg = {
  FE_sg = {
    from_port-1 = 443
    to_port-1   = 443
  }


}
Chewata_back_end_sg = {
  BE_sg = {
    from_port-2 = 5000
    to_port-2   = 5000
  }
}

Chewata_mongo_sg = {
  mongo_sg = {
    from_port-3 = 27017
    to_port-3   = 27017
  }
}

Chewata_ALB_FE = {
  ALB_FE = {
    FE_name_ALB        = "ChewataAlbFE"
    FE_name_TG         = "ChewataALBTargetGroupFE"
    protocol           = "HTTPS"
    port               = 3000
    load_balancer_type = "application"
  }
}

Chewata_Front_End_HC = {
  path                = "/heath"
  protocol            = "HTTPS"
  matcher             = 200
  interval            = 30
  timeout             = 7
  healthy_threshold   = 3
  unhealthy_threshold = 5
}

Chewata_ASG_FE = {
  ASG_FE = {
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

//=====Back-End ALB==========

Chewata_ALB_BE = {
  ALB_BE = {
    BE_name_ALB        = "ChewataAlbBE"
    BE_name_TG         = "ChewataALBTargetGroupBE"
    protocol           = "HTTPS"
    port               = 5000
    load_balancer_type = "application"
  }
}

Chewata_Back_End_HC = {
  path                = "/heath"
  protocol            = "HTTPS"
  matcher             = 200
  interval            = 30
  timeout             = 7
  healthy_threshold   = 3
  unhealthy_threshold = 5
}

//====Back-End ASG ===========

Chewata_ASG_BE = {
  ASG_BE = {
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
