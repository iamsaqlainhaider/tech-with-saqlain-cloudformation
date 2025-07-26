#!/bin/bash

# -------------------------------------------------------------------
# 🚀 Deploying Amazon Connect - EC2 & HealthDashboard Stack
# -------------------------------------------------------------------

# Define fixed and user-defined parameters
_region="ap-southeast-2"
_env="uat"
_bucket="techwithsaqlain-demo-bucket-artifacts"
_template="deploystack.yaml"
_stackname="techwithsaqlain-demo"
_image_ami="ami-01347fdc7a9172350"
_tags="Name=Techwithsaqlain Environment=prod BillingCustomer=Techwithsaqlain"

# Logging the deployment context
echo "🌍 Region      : $_region"
echo "🪣 S3 Bucket   : $_bucket"
echo "📄 Template    : $_template"
echo "📦 Stack Name  : $_stackname"
echo "🖼️  AMI ID     : $_image_ami"
echo "🏷️ Tags        : $_tags"
echo "🏷️ Environment : $_env"

# Deploy the stack using AWS SAM CLI
sam deploy --confirm-changeset \
    --region "$_region" \
    --template-file "$_template" \
    --stack-name "$_stackname" \
    --s3-bucket "$_bucket" \
    --s3-prefix "$_stackname" \
    --tags "$_tags" \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides Imageami="$_image_ami" Env="$_env"

# Check deployment status
if [ $? -eq 0 ]; then
    echo "✅ Deployment complete for stack: $_stackname"
else
    echo "❌ Deployment failed. Please check for errors above."
    exit 1
fi

exit 0
