output "bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "The bucket's global S3 endpoint hostname"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The bucket's regional S3 endpoint hostname"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_hosted_zone_id" {
  description = "The Route53 hosted zone ID for the bucket's S3 endpoint"
  value       = aws_s3_bucket.this.hosted_zone_id
}

output "region" {
  description = "Region where the bucket is created"
  value       = var.region
}

output "bucket_tags" {
  description = "All tags applied to the bucket (including provider defaults)"
  value       = aws_s3_bucket.this.tags_all
}