# Example usage of the S3 module
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0"
}

# Configure the AWS Provider
provider "aws" {
  region                  = var.aws_region
  profile                 = var.aws_profile != "" ? var.aws_profile : null
  access_key              = var.aws_access_key != "" ? var.aws_access_key : null
  secret_key              = var.aws_secret_key != "" ? var.aws_secret_key : null
  token                   = var.aws_session_token != "" ? var.aws_session_token : null
}

# Use the S3 module
module "s3_bucket" {
  source = "../"
  
  bucket_name = var.bucket_name
  region      = var.aws_region
  acl         = var.acl
  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
    DockerDesktop = "true"
  }
}

# Optional: Create a bucket policy for Docker Desktop access
resource "aws_s3_bucket_policy" "docker_desktop_policy" {
  count  = var.create_bucket_policy ? 1 : 0
  bucket = module.s3_bucket.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DockerDesktopAccess"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${module.s3_bucket.bucket_arn}/*"
        Condition = {
          StringEquals = {
            "aws:SourceVpce" = var.vpc_endpoint_id
          }
        }
      }
    ]
  })
}

# Optional: Docker provider and a simple resource to validate connectivity
provider "docker" {
  count = var.enable_docker ? 1 : 0
  host  = var.docker_host != "" ? var.docker_host : null
}

resource "docker_network" "example" {
  count = var.enable_docker ? 1 : 0
  name  = "terraform_example_network"
}
