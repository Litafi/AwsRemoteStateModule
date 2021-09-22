################################################################## 
# AWS S3 Backend Outputs
################################################################## 
output "bucket_id" {
  description = "id of S3 bucket used to terraform store state"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "arn of S3 bucket used to terraform store state"
  value       = aws_s3_bucket.this.arn
}

output "dynamodb_id" {
  description = "id of dynamoDb table for S3 backend locking"
  value       = aws_dynamodb_table.this.id
}

output "dynamodb_arn" {
  description = "arn of dynamoDb table for S3 backend locking"
  value       = aws_dynamodb_table.this.arn
}