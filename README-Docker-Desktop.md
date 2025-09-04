# Terraform S3 Module with Docker Desktop Integration

This guide shows you how to use your Terraform S3 module with Docker Desktop, creating a complete local development environment that integrates with AWS S3.

## Prerequisites

1. **Docker Desktop** installed and running
2. **Terraform** installed (version >= 1.0)
3. **AWS CLI** configured with your credentials
4. **kubectl** (comes with Docker Desktop when Kubernetes is enabled)

## Quick Start

### 1. Enable Kubernetes in Docker Desktop

1. Open Docker Desktop
2. Click the gear icon (Settings)
3. Go to "Kubernetes" tab
4. Check "Enable Kubernetes"
5. Click "Apply & Restart"

### 2. Configure AWS Credentials

```bash
# Option 1: AWS CLI configuration
aws configure

# Option 2: Environment variables
export AWS_ACCESS_KEY_ID=your-access-key
export AWS_SECRET_ACCESS_KEY=your-secret-key
export AWS_DEFAULT_REGION=us-east-1
```

### 3. Create Your S3 Bucket with Terraform

```bash
# Navigate to examples directory
cd examples

# Copy and customize the variables file
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your desired bucket name

# Initialize and apply Terraform
terraform init
terraform plan
terraform apply
```

### 4. Set Up Docker Desktop Integration

**For Linux/macOS:**
```bash
chmod +x scripts/setup-docker-desktop.sh
./scripts/setup-docker-desktop.sh
```

**For Windows:**
```powershell
.\scripts\setup-docker-desktop.ps1
```

### 5. Test the Integration

```bash
# Test S3 access from Docker
docker run -it --rm \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
  amazon/aws-cli s3 ls s3://your-bucket-name

# Test Kubernetes integration
kubectl get configmap s3-bucket-config -o yaml
```

## Using Docker Compose

1. Copy the environment file:
```bash
cp env.example .env
# Edit .env with your actual values
```

2. Update the S3 bucket name in `.env`:
```bash
S3_BUCKET_NAME=your-actual-bucket-name-from-terraform
```

3. Run with Docker Compose:
```bash
docker-compose up -d
```

## Project Structure

```
terraform-s3-module/
├── main.tf                    # Your S3 module
├── variables.tf               # Module variables
├── outputs.tf                 # Module outputs
├── examples/                  # Example usage
│   ├── main.tf               # Example Terraform configuration
│   ├── variables.tf          # Example variables
│   ├── outputs.tf            # Example outputs
│   └── terraform.tfvars.example
├── scripts/                   # Setup scripts
│   ├── setup-docker-desktop.sh
│   └── setup-docker-desktop.ps1
├── docker-compose.yml         # Docker Compose configuration
├── env.example               # Environment variables template
└── README-Docker-Desktop.md  # This file
```

## Workflow

1. **Infrastructure as Code**: Use Terraform to create and manage your S3 bucket
2. **Local Development**: Use Docker Desktop for local application development
3. **Integration**: Connect your local applications to the cloud S3 bucket
4. **Testing**: Test your applications locally before deploying to production

## Benefits

- **Consistent Environment**: Same S3 bucket across development and production
- **Local Development**: Full local development experience with cloud storage
- **Cost Effective**: Use local Docker Desktop instead of EKS for development
- **Easy Testing**: Test S3 integrations locally before deploying

## Troubleshooting

### Docker Desktop Issues
- Ensure Docker Desktop is running
- Check that Kubernetes is enabled in Docker Desktop settings
- Verify kubectl context: `kubectl config current-context`

### AWS Issues
- Verify AWS credentials: `aws sts get-caller-identity`
- Check bucket permissions and region
- Ensure bucket name is globally unique

### Terraform Issues
- Run `terraform init` if you see provider errors
- Check AWS region configuration
- Verify bucket name doesn't already exist

## Next Steps

1. **Deploy Applications**: Use the S3 bucket in your applications
2. **Add CI/CD**: Integrate with GitHub Actions or similar
3. **Monitor**: Set up CloudWatch monitoring for your S3 bucket
4. **Scale**: Move to EKS when ready for production

## Security Notes

- Never commit AWS credentials to version control
- Use IAM roles and policies for production
- Consider VPC endpoints for enhanced security
- Regularly rotate access keys
