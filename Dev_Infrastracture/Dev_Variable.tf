variable "Chewata_Enviroment" {
  description = "This is Enviroment for Chewata_Chat_App"
  type = string
  default = "Development"
}

variable "chewata_cidr_block" {
 description = "Chewata Cidr_Block"
 type = string
 default = "10.0.0.0/16"
}

variable "Chewata_Public_Subnet_AZ" {
  description = "Availability Zone for Public Subnet"
  type = string
  default = "us-west-1a"
}

variable "Chewata_Private_Subnet_AZ" {
  description = "Availability Zone for Private Subnet"
  type = string
  default = "us-east-1a"
}
