# Create SES domain identity and verify it with Route53 DNS records
resource "aws_ses_domain_identity" "ses_domain" {
  domain = var.domain
}

resource "aws_route53_record" "amazonses_verification_record" {
  zone_id = var.zone_id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.ses_domain.verification_token]
}

resource "aws_ses_domain_dkim" "ses_domain_dkim" {
  domain = aws_ses_domain_identity.ses_domain.domain
}

# SES identity policy
data "aws_iam_policy_document" "main" {
  statement {
    actions   = ["SES:SendEmail", "SES:SendRawEmail"]
    resources = [aws_ses_domain_identity.ses_domain.arn]

    principals {
      identifiers = [var.user_arn]
      type        = "AWS"
    }
  }
}

resource "aws_ses_identity_policy" "main" {
  identity = aws_ses_domain_identity.ses_domain.arn
  name     = "sesidentitypolicy"
  policy   = data.aws_iam_policy_document.main.json
}

# Create a user and group with permissions to send emails from SES domain
data "aws_iam_policy_document" "ses_policy" {
  statement {
    actions   = ["SES:SendEmail", "SES:SendRawEmail"]
    resources = [aws_ses_domain_identity.ses_domain.arn]
  }
}

resource "aws_iam_group" "ses_users" {
  name = "SES"
  path = "/ses/"
}

resource "aws_iam_group_policy" "ses_group_policy" {
  name  = "sesgrouppolicy"
  group = aws_iam_group.ses_users.name
  policy = data.aws_iam_policy_document.ses_policy.json
}

resource "aws_iam_user_group_membership" "ses_user" {
  user = var.user_name
  groups = [aws_iam_group.ses_users.name]
}
