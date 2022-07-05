# module "alb_wafv2" {
#   source  = "trussworks/wafv2/aws"
#   version = "2.0.0"

#   name  = "alb-web-acl"
#   scope = "REGIONAL"

#   alb_arn       = aws_lb.main.arn
#   associate_alb = true
# }
