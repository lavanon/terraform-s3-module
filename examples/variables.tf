variable "aws_region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS shared credentials profile name (optional)"
  type        = string
  default     = ""
}

variable "aws_access_key" {
  description = "AWS access key ID (optional; prefer environment variables)"
  type        = string
  default     = ""
}

variable "aws_secret_key" {
  description = "AWS secret access key (optional; prefer environment variables)"
  type        = string
  default     = ""
}

variable "aws_session_token" {
  description = "AWS session token for temporary credentials (optional)"
  type        = string
  default     = ""
}

variable "bucket_name" {
  description = "Name of the S3 bucket (must be globally unique)"
  type        = string
  default     = "docker-desktop-terraform-bucket-${random_id.bucket_suffix.hex}"
}

variable "acl" {
  description = "Access Control List for the bucket"
  type        = string
  default     = "private"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "docker-desktop-terraform"
}

variable "create_bucket_policy" {
  description = "Whether to create a bucket policy for Docker Desktop access"
  type        = bool
  default     = false
}

variable "vpc_endpoint_id" {
  description = "VPC endpoint ID for restricted access (optional)"
  type        = string
  default     = ""
}

# Generate a random suffix for bucket name uniqueness
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

variable "enable_docker" {
  description = "Whether to enable Docker resources (requires Docker Desktop access)"
  type        = bool
  default     = false
}

variable "docker_host" {
  description = "Docker host (e.g., unix:///var/run/docker.sock or npipe:////./pipe/docker_engine). Leave empty for default."
  type        = string
  default     = ""
}
