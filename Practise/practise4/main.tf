/* AWS S3 Bucket Versioning and Encryption
    You need to set up an S3 bucket for storing application logs. The requirements are:

    1. Enable versioning on the S3 bucket to retain previous versions of the logs.
    2. Enable server-side encryption using AWS KMS (Key Management Service) for encryption at rest.
    3. Apply a bucket policy that restricts access to the bucket to a specific IAM role.

*/

provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "name" {
  description = "this is ams key"
}

resource "aws_s3_bucket" "name" {
    bucket = "my-uniquebucket125"
}

resource "aws_s3_bucket_acl" "name" {
    bucket = aws_s3_bucket.name
    acl = "private"
}

resource "aws_s3_bucket_versioning" "name" {
  bucket = aws_s3_bucket.name.id

  versioning_configuration {
    status = enabled
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "name" {
  bucket = aws_s3_bucket.name.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.name
      sse_algorithm = "aws:kms"
    }
  }
}            


resource "aws_s3_bucket" "example" {
  bucket = aws_s3_bucket.name
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.name.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["123456789012"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.example.arn,
      "${aws_s3_bucket.example.arn}/*",
    ]
  }
}