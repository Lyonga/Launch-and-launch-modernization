resource "aws_service_discovery_private_dns_namespace" "amplifier" {
  name        = var.domain_name
  description = "Private dns namespace for service discovery"
  vpc         = var.vpc_id
}

resource "aws_service_discovery_service" "amplifier" {
  name = var.service_name

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.amplifier.id

    dns_records {
      ttl  = var.ttl
      type = var.type
    }

    routing_policy = var.routing_policy
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_instance" "amplifier" {
  instance_id = var.instance_dns
  service_id  = aws_service_discovery_service.amplifier.id

  attributes = {
    AWS_INSTANCE_CNAME = var.instance_dns
    CNAME              = var.instance_dns
  }
}