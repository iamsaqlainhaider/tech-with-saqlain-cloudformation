#!/bin/bash

echo "🚀 Packaging CloudFormation Template for Amazon Connect - EC2 & Lambda Resources"

# Define constants
_region="ap-southeast-2"
_bucket="techwithsaqlain-demo-bucket-artifacts"   # e.g. ensw-connect-nonprod-artifacts-sandpit

echo "🪣 Using S3 Bucket: $_bucket"
echo "🌍 AWS Region: $_region"

# Run sam package
sam package \
    --template-file ec2.yaml \
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
