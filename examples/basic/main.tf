provider "aws" {
  region = "${var.aws_region}"
}

# SQS queue
resource "aws_sqs_queue" "q" {
	name = "${var.sqs_queue_name}"
}

# lambda consumer
module "consumer_test" {
	source = "../../"

	lambda_function_name = "${var.lambda_function_name}"
	lambda_code_bucket = "${var.lambda_code_bucket}"
	lambda_code_path = "${var.lambda_code_path}"
	sqs_queue_name = "${aws_sqs_queue.q.name}"
	iam_prefix = "${var.iam_prefix}"
}
