output "alb_id" {
  value = aws_lb.main.id
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}


output "alb_zone_id" {
  value = aws_lb.main.zone_id
}
