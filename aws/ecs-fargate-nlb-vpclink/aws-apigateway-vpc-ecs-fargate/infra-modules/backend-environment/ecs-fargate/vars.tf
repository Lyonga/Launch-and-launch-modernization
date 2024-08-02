variable "name" {
  type        = string
  description = "The name of the application and the family"
  default     = "amplifier-task"
}

variable "app_image" {
  type = string 
  description = "Container image to be used for application in task definition file"
}

variable "environment" {
  type = string
  description = "amplifier test environment"
}

variable "fargate_cpu" {
  type = number
  description = "Fargate cpu allocation"
  default = 512
}

variable "fargate_memory" {
  type = number
  description = "Fargate memory allocation"
  default     = 1024
}

variable "app_port" {
  type = number
  description = "Application port"
  default     = 80
}

variable "public_subnet_ids" {
  type = list(string)
  description = "IDs for private subnets"
  default = "[aws_subnet.public1.id, aws_subnet.public2.id]"
}

variable "vpc_id" {
  type = string 
  description = "The id for the VPC where the ECS container instance should be deployed"
  default = "aws_vpc.custom_vpc.id"
}

variable "cluster_id" {
  type = string 
  description = "Cluster ID"
  default = ""
}

variable "app_count" {
  type = string 
  description = "The number of instances of the task definition to place and keep running."
}

variable "aws_security_group_ecs_tasks_id" {
  type = string 
  description = "The ID of the security group for the ECS tasks"
}