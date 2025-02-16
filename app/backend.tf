terraform {
  backend "s3" {
    bucket = "tf-backend-bucstop"
    key    = "~/.aws/credentials"
    region = "us-east-2"
  }
}
