provider "aws" {
  region = "us-east-1"
}

# S3 Bucket
resource "aws_s3_bucket" "name" {
  bucket = "my-example-bucket"
}

# Public Read Access Policy
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.name.id

  policy = data.aws_iam_policy_document.public_read.json
}

data "aws_iam_policy_document" "public_read" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.name.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"] # Public access
    }
  }
}

# IAM User
resource "aws_iam_user" "example_user" {
  name = "example-user"
}

# IAM Policy for PutObject
resource "aws_iam_policy" "s3_upload_policy" {
  name   = "S3UploadPolicy"
  policy = data.aws_iam_policy_document.s3_upload_policy.json
}

data "aws_iam_policy_document" "s3_upload_policy" {
  statement {
    actions = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.name.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.example_user.arn]
    }
  }
}

resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.example_user.name
  policy_arn = aws_iam_policy.s3_upload_policy.arn
}
