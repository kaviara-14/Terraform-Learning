provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
    bucket = "my-terraform-bucket-12345677"
}

resource "aws_s3_bucket_acl" "example" {
    bucket = aws_s3_bucket.example.id
    acl = "private"
}

resource "aws_s3_bucket_versioning" "name" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "enabled"
  }
}


output "name" {
  value = aws_s3_bucket.example.bucket
}

