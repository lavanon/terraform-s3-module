# Terraform S3 Bucket Module

A simple Terraform module for creating AWS S3 buckets with configurable settings.

## Features

- Creates S3 buckets with customizable names
- Configurable ACL settings
- Customizable tags
- Configurable AWS region

## Usage

```hcl
module "s3_bucket" {
  source = "./terraform-s3-module"
  
  bucket_name = "my-unique-bucket-name"
  region     = "us-east-1"
  acl        = "private"
  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket_name | Name of the S3 bucket | `string` | n/a | yes |
| region | AWS region where the bucket will be created | `string` | `"us-east-1"` | no |
| acl | Access Control List for the bucket | `string` | `"private"` | no |
| tags | Tags to apply to the bucket | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | The name of the bucket |
| bucket_arn | The ARN of the bucket |
| bucket_domain_name | The bucket's global S3 endpoint hostname |
| bucket_regional_domain_name | The bucket's regional S3 endpoint hostname |
| bucket_hosted_zone_id | The Route53 hosted zone ID for the bucket's S3 endpoint |
| region | Region where the bucket is created |
| bucket_tags | All tags applied to the bucket (including provider defaults) |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.0 |

## Example

```hcl
# Create a simple S3 bucket
module "example_bucket" {
  source      = "./terraform-s3-module"
  bucket_name = "my-example-bucket-2025"
  region      = "us-west-2"
  tags = {
    Environment = "development"
    Owner       = "DevOps Team"
  }
}
```

## License

This module is provided as-is for educational and development purposes.

