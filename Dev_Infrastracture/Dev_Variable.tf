variable "Chewata_Enviroment" {
  description = "This is Enviroment for Chewata_Chat_App"
  type        = string
  default     = "Development"
}

variable "chewata_cidr_block" {
  description = "Chewata Cidr_Block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "Chewata_Public_Subnet_AZ" {
  description = "Availability Zone for Public Subnet"
  type        = string
  default     = "us-west-1a"
}

variable "Chewata_Private_Subnet_AZ" {
  description = "Availability Zone for Private Subnet"
  type        = string
  default     = "us-east-1a"
}

variable "Chewata_front_end_sg" {
  description = "Front-End Security Group"
  type = map(object({
    from_port-1 = number
    to_port-1   = number
  }))
  #   default = {
  #     from_port = 3000
  #     from_port = 433
  #   }
}

variable "Chewata_back_end_sg" {
  description = "Back-End Security Group"
  type = map(object({
    from_port-2 = number
    to_port-2   = number
  }))
}

#  default = {
#     from_port = 5000
#     to_port   = 5000

variable "Chewata_MongoDB_sg" {
  description = "MongoDB Security Group"
  type        = map(number)
  default = {
    from_port = 27017
    to_port   = 27017
  }
}
//===Front-End======
variable "Chewata_ALB_FE" {
  description = "Chewata Application Load Balancer"
  type = map(object({
    FE_name_ALB        = string
    FE_name_TG         = string
    load_balancer_type = string
    port               = number
    protocol           = string
  }))

}

variable "Chewata_Front_End_HC" {
  description = "Front-End ALB Heath Check"
  type = object({
    path                = string
    protocol            = string
    matcher             = number
    interval            = number
    timeout             = number
    healthy_threshold   = number
    unhealthy_threshold = number
  })
}

variable "Chewata_ASG_FE" {
  description = "Front-End Auto-Scaling Group"
  type = map(object({
    name             = string
    min              = number
    max              = number
    desired_capacity = number
    EC2_name         = string
    image_id         = string
    instance_type    = string
    grace_period     = number

  }))
}

//=====Back-End=====

variable "Chewata_ALB_BE" {
  description = "Chewata Application Load Balancer"
  type = map(object({
    BE_name_ALB        = string
    BE_name_TG         = string
    load_balancer_type = string
    port               = number
    protocol           = string
  }))

}

variable "Chewata_Back_End_HC" {
  description = "Front-End ALB Heath Check"
  type = object({
    path                = string
    protocol            = string
    matcher             = number
    interval            = number
    timeout             = number
    healthy_threshold   = number
    unhealthy_threshold = number
  })
}