variable "lambda_function_name" {
	description = "Lambda function name"
}

variable "lambda_code_bucket" {
	description = "S3 bucket for storing lambda code"
}

variable "lambda_code_bucket_key" {
	description = "S3 key - lambda code (zip) will be stored under this key"
	default = "func.zip"
}

variable "lambda_code_path" {
	description = "Local path to your code ZIP file"
	default = "./lambda/func.zip"
}

variable "lambda_handler" {
	description = "Lambda handler"
	default = "index.handler"
}

variable "lambda_runtime" {
	description = "Lambda runtime version"
	default = "nodejs8.10"
}

variable "lambda_timeout" {
	description = "Lambda timeout (in seconds)"
	default = 25
}

variable "lambda_memsize" {
	description = "Lambda memory size"
	default = 128
}

variable "lambda_vpc_security_group_ids" {
	description = "Lambda VPC security group IDs list"
	default = []
}

variable "lambda_vpc_subnet_ids" {
	description = "Lambda VPC subnet IDs list"
	default = []
}

variable "sqs_queue_name" {
	description = "SQS queue name"
}

variable "iam_prefix" {
	description = "Created IAM policies and roles will have this prefix"
}
