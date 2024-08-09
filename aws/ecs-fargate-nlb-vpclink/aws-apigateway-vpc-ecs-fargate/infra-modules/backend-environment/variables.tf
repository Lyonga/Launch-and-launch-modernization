# variable "profile" {
#   description = "AWS profile"
#   type        = string
# }

variable "region" {
  description = "aws region to deploy to"
  type        = string
  default = us-east-1
}

variable "platform_name" {
  description = "The name of the platform"
  type = string
  default = amplifier
}

variable "environment" {
  description = "Applicaiton environment"
  type = string
  default = dev
}

variable "app_port" {
  description = "Application port"
  type = number
  default = 80
}

variable "app_image" {
  type = string 
  description = "Container image to be used for application in task definition file"
}

variable "availability_zones" {
  type  = list(string)
  description = "List of availability zones for the selected region"
  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}

variable "app_count" {
  type = number 
  description = "The number of instances of the task definition to place and keep running."
  default = 1
}

/* variable "main_pvt_route_table_id" {
  type        = string
  description = "Main route table id"
} */