#!/bin/bash

echo "🚀 Deploying Amazon Connect - EC2 & HealthDashboard Stack"

# Check for required environment argument
if [ $# -ne 1 ]; then
    echo "❌ Usage: $0 <environment>"
    echo "🔁 Example: $0 sandpit"
    exit 1
fi

# Assign parameters
_environ="$1"
_keypair="demo"  # Default key pair name
_keyfile="demo.pem"
_region="ap-southeast-2"

echo "📦 Environment: ${_environ}"
echo "🔐 Using KeyPairName: ${_keypair}"

# Check if key pair exists
if ! aws ec2 describe-key-pairs --key-names "$_keypair" --region "$_region" > /dev/null 2>&1; then
    echo "🔧 Key pair '$_keypair' not found. Creating it now..."

    aws ec2 create-key-pair \
        --key-name "$_keypair" \
        --query 'KeyMaterial' \
        --output text \
        --region "$_region" > "$_keyfile"

    if [ $? -ne 0 ]; then
        echo "❌ Failed to create key pair."
        exit 1
    fi

    chmod 400 "$_keyfile"
    echo "✅ Key pair '$_keypair' created and saved to $_keyfile"
else
    echo "✅ Key pair '$_keypair' already exists in region $_region."
fi

# Define tags
_tag="Name=amazonconnect Environment=${_environ} BillingCustomer=amazonconnect"

# Template
_template="deploystack.yaml"

# Bucket logic
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
        echo "❌ Invalid environment: ${_environ}. Use sandpit, dev, uat, or prod."
        exit 1
        ;;
esac

# Parameter overrides
_param="EnvironmentStage=${_environ} KeyPairName=${_keypair}"

# Deploy the stack
sam deploy --confirm-changeset \
    --region "$_region" \
    --template-file "$_template" \
    --stack-name "connect-${_environ}-cicd-health" \
    --s3-bucket "$_bucket" \
    --s3-prefix "connect-${_environ}-cicd-health" \
    --tags "$_tag" \
    --parameter-overrides $_param \
    --capabilities CAPABILITY_NAMED_IAM

echo "✅ Deployment complete for environment: ${_environ}"
exit 0
