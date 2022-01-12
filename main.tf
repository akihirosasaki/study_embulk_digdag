# s3, bigqueryの環境構成を指定

resource "google_bigquery_dataset" "bigquery_dataset" {
  dataset_id    = "asasaki_data_infra_dataset"
  friendly_name = "asasaki_data_infra_dataset"
  location      = "asia-northeast1"
}

resource "google_bigquery_table" "bigquery_table" {
  dataset_id          = google_bigquery_dataset.bigquery_dataset.dataset_id
  table_id            = "asasaki_data_infra_table"
  schema              = file("./bigquery/schema_asasaki-data-infra-table.json")
  deletion_protection = false
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "asasaki-data-infra-s3"
  acl    = "private"
}