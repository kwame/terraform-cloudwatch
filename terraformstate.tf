terraform {
  backend "s3" {
    bucket = "informatux-terraform-test"
    key    = "ops_vpc/ops_vpc.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
