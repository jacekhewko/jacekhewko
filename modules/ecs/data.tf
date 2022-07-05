# data "aws_elb_service_account" "main" {}

# data "aws_iam_policy_document" "s3_lb" {
#   statement {
#     effect = "Allow"
#     actions = ["s3:PutObject"]
#     resources = [
#         "arn:aws:s3:::beislogs*/*",
#         "arn:aws:s3:::beislogs*",
#     ]

#     principals {
#       identifiers = ["${data.aws_elb_service_account.main.arn}"]
#       type = "AWS"
#     }
#   }
# }

data "aws_caller_identity" "current" {}

data "aws_iam_role" "ecs" {
  name = "ecsTaskExecutionRole"
}