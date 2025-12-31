# Create the S3 bucket for Terraform state
export AWS_REGION="eu-south-2" # Spain
export AWS_PROFILE="default" # change if you use a named profile

export TFSTATE_BUCKET="platform-engineering-lab-tfstate-$(date +%Y%m%d)-$RANDOM"

aws s3api create-bucket \
  --bucket "$TFSTATE_BUCKET" \
  --region "$AWS_REGION" \
  --create-bucket-configuration LocationConstraint="$AWS_REGION"

# versioning (recommended)
aws s3api put-bucket-versioning \
  --bucket "$TFSTATE_BUCKET" \
  --versioning-configuration Status=Enabled

# block public access (recommended)
aws s3api put-public-access-block \
  --bucket "$TFSTATE_BUCKET" \
  --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
  