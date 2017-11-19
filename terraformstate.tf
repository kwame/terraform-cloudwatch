terraform {
  backend "s3" {
    bucket = "informatux-terraform-test"
    key    = "terraform-testc/informatux-cloudwatch.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
