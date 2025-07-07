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

variable "Chewata_ALB" {
  description = "Chewata Application Load Balancer"
  type = map(string)
 default = {
   "name" = "ChewataALB"
 }
}
