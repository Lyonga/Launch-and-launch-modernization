variable "family" {
  type    = string
  default = "amplifier-family"
}

variable "vpc_id" {
  type    = string
  default = "aws_vpc.custom_vpc.id"
}

variable "ingress_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "subnet_ids" {
  type    = list(string)
  default = [""]
}

variable "ecs_service_name" {
  type    = string
  default = "amplifier"
}

variable "service_name" {
  type    = string
  default = "amplifier"
}

variable "domain_name" {
  type    = string
  default = "amplifier"
}

variable "instance_dns" {
  type    = string
  default = "amplifier"
}

variable "desired_count" {
  type    = string
  default = "1"
}

variable "cluster_cloud_watch_log_group_name" {
  type    = string
  default = "amplifier-log-group"
}