resource "aws_route53_zone" "zone" {
  name = var.r53_zone
}

resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = var.api_dns_record
  type    = "CNAME"
  ttl     = "60"
  records = [var.record]
}

resource "aws_route53_record" "react" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = var.react_dns_record
  type    = "CNAME"
  ttl     = "60"
  records = [var.record]
}

resource "aws_route53_record" "horizon" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = var.horizon_dns_record
  type    = "CNAME"
  ttl     = "60"
  records = [var.record]
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

subject_alternative_names = [
    "*.${var.domain_name}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "main" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
   # Skips the domain if it doesn't contain a wildcard
    if length(regexall("\\*\\..+", dvo.domain_name)) > 0
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.main : record.fqdn]
}
