# FIX: Use data source — your hosted zone already exists, don't create a new one
# Creating a new one would break your domain's DNS
data "aws_route53_zone" "primary" {
  name         = var.domain_name
  private_zone = false
}

# ACM DNS validation records
resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in var.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.primary.zone_id
}

# FIX: Record must be tm.<domain> not just <domain>
resource "aws_route53_record" "tm" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "tm.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
