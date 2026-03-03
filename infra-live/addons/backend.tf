terraform {
  backend "s3" {
    bucket         = "enterprise-txn-tf-state-202603"
    key            = "addons/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "enterprise-txn-tf-lock"
  }
}
