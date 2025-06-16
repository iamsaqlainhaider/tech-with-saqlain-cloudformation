#!/bin/bash

echo "🚀 Packaging CloudFormation Template for Amazon Connect - EC2 & Lambda Resources"

# Check for environment argument
_environ="$1"
echo "📦 Environment: $_environ"

if [ $# -ne 1 ]; then
    echo "❌ Usage: $0 <environment>"
    echo "🔁 Example: $0 sandpit"
    exit 1
fi

# Define region
_region="ap-southeast-2"

# Determine the correct S3 bucket and package
case $_environ in
    "sandpit")
        _bucket="ensw-connect-nonprod-artifacts-sandpit"
        ;;
    "dev")
        _bucket="techwithsaqlain-demo-bucket-artifacts"
        ;;
    "uat")
        _bucket="ensw-connect-nonprod-artifacts"
        ;;
    "prod")
        _bucket="ehealth-connect-lambda-artifacts"
        ;;
    *)
        echo "❌ Invalid environment: $_environ. Valid environments are sandpit, dev, uat, prod."
        exit 1
        ;;
esac

echo "🪣 Using S3 Bucket: $_bucket"
echo "🌍 AWS Region: $_region"

# Run sam package
sam package \
    --template-file template.yaml \
    --output-template-file deploystack.yaml \
    --s3-bucket "$_bucket" \
    --region "$_region"

if [ $? -eq 0 ]; then
    echo "✅ Packaging complete. Output: deploystack.yaml"
else
    echo "❌ Packaging failed. Please check for errors in the template."
    exit 1
fi

exit 0
