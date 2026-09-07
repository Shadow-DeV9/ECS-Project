output "zone_id" {
  value = aws_route53_zone.primary.zone_id
}

output "name_servers" {
  value = aws_route53_zone.primary.name_servers
}

output "acm_validation_record_fqdns" {
  value = [for record in aws_route53_record.acm_validation : record.fqdn]
}
