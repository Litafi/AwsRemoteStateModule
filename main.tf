############################################################################
# AWS S3 Backend Resources
############################################################################

resource "aws_s3_bucket" "this" {
  acl    = var.bucket_acl_value
  bucket = var.bucket_name

  tags = merge(
    var.tags, 
    {
      "aws_service" = "s3"
    }
  )

  force_destroy = var.force_destroy

  # Enable versioning so we can see the full 
  # revision history of our state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.s3Backend.json
}


data "aws_iam_policy_document" "s3Backend" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    principals {
      type        = "AWS"
      identifiers = ["${var.bucket_principal}"]
    }
    resources = [
      "${aws_s3_bucket.this.arn}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["${var.bucket_principal}"]
    }
  }
}

resource "aws_dynamodb_table" "this" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 20
  write_capacity = 20

  # https://www.terraform.io/docs/backends/types/s3.html#dynamodb_table
  hash_key = "LockID"

  server_side_encryption {
    enabled = true
  }

  lifecycle {
    ignore_changes = [
      billing_mode,
      read_capacity,
      write_capacity,
    ]
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(
    var.tags, 
    {
      "aws_service" = "dynamodb"
    }
  )
}
