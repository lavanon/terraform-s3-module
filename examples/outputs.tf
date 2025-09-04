output "bucket_id" {
  description = "The ID of the S3 bucket"
  value       = module.s3_bucket.bucket_id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.s3_bucket.bucket_arn
}

output "bucket_domain_name" {
  description = "The bucket's global S3 endpoint hostname"
  value       = module.s3_bucket.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The bucket's regional S3 endpoint hostname"
  value       = module.s3_bucket.bucket_regional_domain_name
}

output "aws_region" {
  description = "AWS region where the bucket was created"
  value       = module.s3_bucket.region
}

output "docker_desktop_config" {
  description = "Configuration for Docker Desktop integration"
  value = {
    bucket_name = module.s3_bucket.bucket_id
    region      = module.s3_bucket.region
    endpoint    = module.s3_bucket.bucket_regional_domain_name
  }
}
