#!/bin/bash

echo "🚀 Deploying Amazon Connect - EC2 & HealthDashboard Stack"

# Fixed parameters

            # e.g. static stack name

_tags="Name=Techwithsaqlain Environment=prod BillingCustomer=Techwithsaqlain"
_instance_type="t3.micro"



echo "🌍 Region      : $_region"
echo "🪣 S3 Bucket   : $_bucket"
echo "📄 Template    : $_template"
echo "📦 Stack Name  : $_stackname"

# Deploy the stack
sam deploy --confirm-changeset \
    --region ap-southeast-2 \
    --template-file deploystack.yaml \
    --stack-name techwithsaqlain-demo \
    --s3-bucket techwithsaqlain-demo-bucket-artifacts \
    --s3-prefix techwithsaqlain-demo  \
    --tags "$_tags" \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides InstanceType="$_instance_type"


if [ $? -eq 0 ]; then
    echo "✅ Deployment complete for stack: $_stackname"
else
    echo "❌ Deployment failed. Please check for errors above."
    exit 1
fi

exit 0
