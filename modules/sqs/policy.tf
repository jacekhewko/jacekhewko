resource "aws_sqs_queue_policy" "main" {
  queue_url = aws_sqs_queue.main.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "Allow-User-SendMessage",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.sqs_user_arn}"
      },
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.main.arn}"
    }
  ]
}
POLICY
}
