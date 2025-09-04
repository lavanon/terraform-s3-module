# PowerShell script for Windows users
# Setup script for Docker Desktop with Terraform S3 integration

Write-Host "🐳 Setting up Docker Desktop with Terraform S3 integration..." -ForegroundColor Cyan

# Check if Docker Desktop is running
try {
    docker info | Out-Null
    Write-Host "✅ Docker Desktop is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker Desktop is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}

# Check if Kubernetes is enabled
try {
    $context = kubectl config current-context
    if ($context -notlike "*docker-desktop*") {
        Write-Host "⚠️  Kubernetes is not enabled in Docker Desktop." -ForegroundColor Yellow
        Write-Host "Please enable Kubernetes in Docker Desktop settings:" -ForegroundColor Yellow
        Write-Host "1. Open Docker Desktop" -ForegroundColor Yellow
        Write-Host "2. Go to Settings (gear icon)" -ForegroundColor Yellow
        Write-Host "3. Navigate to 'Kubernetes' tab" -ForegroundColor Yellow
        Write-Host "4. Check 'Enable Kubernetes'" -ForegroundColor Yellow
        Write-Host "5. Click 'Apply & Restart'" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "After enabling Kubernetes, run this script again." -ForegroundColor Yellow
        exit 1
    }
    Write-Host "✅ Kubernetes is enabled in Docker Desktop" -ForegroundColor Green
} catch {
    Write-Host "❌ kubectl not found. Please install kubectl or ensure it's in your PATH." -ForegroundColor Red
    exit 1
}

# Get Terraform outputs if available
if (Test-Path "../examples/terraform.tfstate") {
    Write-Host "📋 Reading Terraform outputs..." -ForegroundColor Cyan
    
    try {
        Push-Location "../examples"
        $bucketName = terraform output -raw bucket_id 2>$null
        $awsRegion = terraform output -raw aws_region 2>$null
        Pop-Location
        
        if ($bucketName -and $awsRegion) {
            Write-Host "✅ Found S3 bucket: $bucketName in region: $awsRegion" -ForegroundColor Green
            
            # Create a ConfigMap with S3 bucket information
            $configMapYaml = @"
apiVersion: v1
kind: ConfigMap
metadata:
  name: s3-bucket-config
data:
  bucket-name: "$bucketName"
  aws-region: "$awsRegion"
"@
            
            $configMapYaml | kubectl apply -f -
            Write-Host "✅ Created Kubernetes ConfigMap with S3 bucket configuration" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Could not read Terraform outputs. Make sure you've run 'terraform apply' in the examples directory." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "⚠️  Error reading Terraform outputs: $($_.Exception.Message)" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️  No Terraform state found. Please run 'terraform apply' in the examples directory first." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎉 Setup complete! Your Docker Desktop is now configured to work with Terraform." -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Make sure your AWS credentials are configured (aws configure or environment variables)" -ForegroundColor White
Write-Host "2. Deploy your applications using kubectl or Docker Compose" -ForegroundColor White
Write-Host "3. Use the S3 bucket for storing application data, logs, or artifacts" -ForegroundColor White
Write-Host ""
Write-Host "Useful commands:" -ForegroundColor Cyan
Write-Host "  kubectl get configmap s3-bucket-config -o yaml  # View S3 configuration" -ForegroundColor White
Write-Host "  docker run -it --rm amazon/aws-cli s3 ls        # Test S3 access" -ForegroundColor White
