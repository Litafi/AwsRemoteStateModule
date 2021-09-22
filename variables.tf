################################################################## 
# AWS S3 Backend Variables
################################################################## 
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Tags to set for all resources"
}

variable "force_destroy" {
  type        = bool
  description = "enables destruction of bucket (and all objects in bucket).Only true in development environment"
}

variable "bucket_name" {
  type        = string
  description = "name of s3 bucket used to store remote state"
}

variable "bucket_acl_value" {
  type        = string
  default     = "private"
  description = "make s3 bucket private or public. Default is private"
}

variable "bucket_principal" {
  type        = string
  description = "principal allowed access to terraform backend bucket"
}

variable "table_name" {
  type        = string
  description = "name of dynamoDb table used to store remote state"
}
