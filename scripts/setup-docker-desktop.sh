#!/bin/bash

# Setup script for Docker Desktop with Terraform S3 integration
# This script helps you configure Docker Desktop to work with your Terraform-created S3 bucket

set -e

echo "🐳 Setting up Docker Desktop with Terraform S3 integration..."

# Check if Docker Desktop is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker Desktop is not running. Please start Docker Desktop first."
    exit 1
fi

echo "✅ Docker Desktop is running"

# Check if Kubernetes is enabled
if ! kubectl config current-context | grep -q "docker-desktop"; then
    echo "⚠️  Kubernetes is not enabled in Docker Desktop."
    echo "Please enable Kubernetes in Docker Desktop settings:"
    echo "1. Open Docker Desktop"
    echo "2. Go to Settings (gear icon)"
    echo "3. Navigate to 'Kubernetes' tab"
    echo "4. Check 'Enable Kubernetes'"
    echo "5. Click 'Apply & Restart'"
    echo ""
    echo "After enabling Kubernetes, run this script again."
    exit 1
fi

echo "✅ Kubernetes is enabled in Docker Desktop"

# Get Terraform outputs if available
if [ -f "../examples/terraform.tfstate" ]; then
    echo "📋 Reading Terraform outputs..."
    
    BUCKET_NAME=$(terraform -chdir=../examples output -raw bucket_id 2>/dev/null || echo "")
    AWS_REGION=$(terraform -chdir=../examples output -raw aws_region 2>/dev/null || echo "")
    
    if [ -n "$BUCKET_NAME" ] && [ -n "$AWS_REGION" ]; then
        echo "✅ Found S3 bucket: $BUCKET_NAME in region: $AWS_REGION"
        
        # Create a ConfigMap with S3 bucket information
        kubectl create configmap s3-bucket-config \
            --from-literal=bucket-name="$BUCKET_NAME" \
            --from-literal=aws-region="$AWS_REGION" \
            --dry-run=client -o yaml | kubectl apply -f -
        
        echo "✅ Created Kubernetes ConfigMap with S3 bucket configuration"
    else
        echo "⚠️  Could not read Terraform outputs. Make sure you've run 'terraform apply' in the examples directory."
    fi
else
    echo "⚠️  No Terraform state found. Please run 'terraform apply' in the examples directory first."
fi

echo ""
echo "🎉 Setup complete! Your Docker Desktop is now configured to work with Terraform."
echo ""
echo "Next steps:"
echo "1. Make sure your AWS credentials are configured (aws configure or environment variables)"
echo "2. Deploy your applications using kubectl or Docker Compose"
echo "3. Use the S3 bucket for storing application data, logs, or artifacts"
echo ""
echo "Useful commands:"
echo "  kubectl get configmap s3-bucket-config -o yaml  # View S3 configuration"
echo "  docker run -it --rm amazon/aws-cli s3 ls        # Test S3 access"
