variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Prefix for naming resources"
  type        = string
  default     = "ecommerce"
}