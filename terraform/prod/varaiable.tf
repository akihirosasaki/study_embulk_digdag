# 各環境で指定する変数を記載
variable "gcp_project_id" {}
variable "GOOGLE_APPLICATION_CREDENTIALS" {
  default = "/run/secrets/gcp_secret"
}
variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}
variable "DB_USER" {}
variable "DB_USER_PASSWORD" {}
variable "DB_NAME" {}