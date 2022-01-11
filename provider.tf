# aws, gcpのプロバイダ情報を指定
provider "google" {
  project     = var.gcp_project_id
  region      = "asia-northeast1"
  credentials = "${file(var.GOOGLE_APPLICATION_CREDENTIALS)}"
}

provider "aws" {
  region      = "ap-northeast-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}