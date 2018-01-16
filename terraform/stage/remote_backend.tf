terraform {
  backend "gcs" {
    bucket = "enkov-terraform-state"
    prefix = "stage/terraform.tfstate"
  }
}
