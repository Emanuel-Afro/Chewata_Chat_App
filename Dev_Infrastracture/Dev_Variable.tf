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
  type        = map(number)
  default = {
    from_port = 3000
    from_port = 433
  }
}

variable "Chewata_back_end_sg" {
  description = "Back-End Security Group"
  type        = map(number)
  default = {
    from_port = 5000
    to_port   = 5000

  }
}

variable "Chewata_MongoDB_sg" {
  description = "MongoDB Security Group"
  type        = map(number)
  default = {
    from_port = 27017
    to_port   = 27017
  }
}

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
# variable "Chewata_Front_end_EC2" {
#   description = "Chewata Front-End application EC2 Instances"
#  type = map(string)
#  default = {
#    "Chewata_EC2_Front_End_1" = "Chewata_Dev_FE_1"
#    "Chewata_EC2_Front_End_1" = "Chewata_Dev_FE_2"
#    ami = "ami-0b6d52d4a526e3ec3"
#  }

# }

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
