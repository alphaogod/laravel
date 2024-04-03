provider "aws" {
  region = "ap-south-1"
}

#-------------------#
#terrafrom backend
#-------------------#
terraform {
  backend "s3" {
    bucket         = "mylaravalappbucket"
    key            = "mylaravalappbucket/teraform/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "laraval-terraform-state-locking"
    encrypt        = true
  }
}