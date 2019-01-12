output "lambda_role_name" {
	value = "${aws_iam_role.lambda_consumer_r.name}"
}

output "lambda_role_arn" {
	value = "${aws_iam_role.lambda_consumer_r.arn}"
}
