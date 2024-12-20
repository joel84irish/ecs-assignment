terraform {
  required_version = ">=1.0.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0" 
    }
  }
}
provider "aws" {}

# S3 Bucket for TF State File
resource "aws_s3_bucket" "terraform_state" {
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_crypto_conf" {
  bucket = aws_s3_bucket.terraform_state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Dynamo DB Table for Locking TF Config
resource "aws_dynamodb_table" "terraform_lock1" {
  name         = "Joel-terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
