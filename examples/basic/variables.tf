variable "aws_region" {
	description = "AWS region"
	default = "eu-central-1"
}

variable "lambda_function_name" {
	description = "Lambda function name"
}

variable "lambda_code_bucket" {
	description = "S3 bucket for storing lambda code"
}

variable "lambda_code_path" {
	description = "Local path to your code ZIP file"
	default = "./lambda/func.zip"
}

variable "sqs_queue_name" {
	description = "SQS queue name"
}

variable "iam_prefix" {
	description = "Created IAM policies and roles will have this prefix"
}
