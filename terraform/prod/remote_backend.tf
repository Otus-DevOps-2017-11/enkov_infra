terraform {
  backend "gcs" {
    bucket = "enkov-terraform-state"
    prefix = "prod/terraform.tfstate"
  }
}
