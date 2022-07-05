output "certificate_arn" { value = aws_acm_certificate_validation.main.certificate_arn }
output "zone_id" { value = aws_route53_zone.zone.zone_id }