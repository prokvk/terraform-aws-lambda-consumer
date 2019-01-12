output "lambda_role_name" {
	value = "${aws_iam_role.lambda_consumer_r.name}"
	description = "Created IAM role for lambda function - name"
}

output "lambda_role_arn" {
	value = "${aws_iam_role.lambda_consumer_r.arn}"
	description = "Created IAM role for lambda function - ARN"
}
