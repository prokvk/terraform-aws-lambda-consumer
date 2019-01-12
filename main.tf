# SQS queue
data "aws_sqs_queue" "lambda_consumer_q" {
	name = "${var.sqs_queue_name}"
}

# S3 bucket for lambda code
resource "aws_s3_bucket" "lambda_consumer_b" {
	bucket = "${var.lambda_code_bucket}"
	acl = "private"
	server_side_encryption_configuration = {
		rule {
			apply_server_side_encryption_by_default {
				sse_algorithm = "AES256"
			}
		}
	}
}

# put lambda code to S3
resource "aws_s3_bucket_object" "lambda_consumer_bo" {
	bucket = "${aws_s3_bucket.lambda_consumer_b.bucket}"
	key = "${var.lambda_code_bucket_key}"
	source = "${var.lambda_code_path}"
}


# IAM permissions
resource "aws_iam_policy" "lambda_consumer_p" {
	name = "${var.iam_prefix}_logs"
	policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Action": ["logs:*"],
			"Resource": "arn:aws:logs:*:*:*",
			"Effect": "Allow"
		}
	]
}
EOF
}

resource "aws_iam_policy" "lambda_consumer_sqsp" {
	name = "${var.iam_prefix}_sqs"
	policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Action": ["sqs:*"],
			"Resource": "${data.aws_sqs_queue.lambda_consumer_q.arn}",
			"Effect": "Allow"
		}
	]
}
EOF
}

resource "aws_iam_role" "lambda_consumer_r" {
	name = "${var.iam_prefix}_main"
	assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Action": ["sts:AssumeRole"],
			"Principal": {
				"Service": "lambda.amazonaws.com"
			},
			"Effect": "Allow"
		}
	]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_consumer_a" {
	role = "${aws_iam_role.lambda_consumer_r.name}"
	policy_arn = "${aws_iam_policy.lambda_consumer_p.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda_consumer_sqsa" {
	role = "${aws_iam_role.lambda_consumer_r.name}"
	policy_arn = "${aws_iam_policy.lambda_consumer_sqsp.arn}"
}

# lambda func - no VPC config
resource "aws_lambda_function" "lambda_consumer_f" {
	s3_bucket = "${aws_s3_bucket.lambda_consumer_b.bucket}"
	s3_key = "${var.lambda_code_bucket_key}"
	function_name = "${var.lambda_function_name}"
	role = "${aws_iam_role.lambda_consumer_r.arn}"
	handler = "${var.lambda_handler}"
	runtime = "${var.lambda_runtime}"
	timeout = "${var.lambda_timeout}"
	memory_size = "${var.lambda_memsize}"

	depends_on = ["aws_s3_bucket_object.lambda_consumer_bo"]

	count = "${length(var.lambda_vpc_security_group_ids) != 0 && length(var.lambda_vpc_subnet_ids) != 0 ? 0 : 1}"
}

# lambda event source mapping - no VPC config
resource "aws_lambda_event_source_mapping" "lambda_consumer_m" {
	event_source_arn = "${data.aws_sqs_queue.lambda_consumer_q.arn}"
	function_name = "${aws_lambda_function.lambda_consumer_f.arn}"

	count = "${length(var.lambda_vpc_security_group_ids) != 0 && length(var.lambda_vpc_subnet_ids) != 0 ? 0 : 1}"
}

# lambda func - VPC config
resource "aws_lambda_function" "lambda_consumer_fvpc" {
	s3_bucket = "${aws_s3_bucket.lambda_consumer_b.bucket}"
	s3_key = "${var.lambda_code_bucket_key}"
	function_name = "${var.lambda_function_name}"
	role = "${aws_iam_role.lambda_consumer_r.arn}"
	handler = "${var.lambda_handler}"
	runtime = "${var.lambda_runtime}"
	timeout = "${var.lambda_timeout}"
	memory_size = "${var.lambda_memsize}"

	depends_on = ["aws_s3_bucket_object.lambda_consumer_bo"]

	vpc_config = {
		subnet_ids = "${var.lambda_vpc_subnet_ids}"
		security_group_ids = "${var.lambda_vpc_security_group_ids}"
	}

	count = "${length(var.lambda_vpc_security_group_ids) != 0 && length(var.lambda_vpc_subnet_ids) != 0 ? 1 : 0}"
}

# lambda event source mapping - VPC config
resource "aws_lambda_event_source_mapping" "lambda_consumer_mvpc" {
	event_source_arn = "${data.aws_sqs_queue.lambda_consumer_q.arn}"
	function_name = "${aws_lambda_function.lambda_consumer_fvpc.arn}"

	count = "${length(var.lambda_vpc_security_group_ids) != 0 && length(var.lambda_vpc_subnet_ids) != 0 ? 1 : 0}"
}
