# s3, bigqueryの環境構成を指定

resource "google_bigquery_dataset" "bigquery_dataset" {
  dataset_id    = "asasaki-data-infra-dataset"
  friendly_name = "asasaki-data-infra-dataset"
  location      = "asia-northeast1"
}

resource "google_bigquery_table" "bigquery_table" {
  dataset_id          = google_bigquery_dataset.bigquery_dataset.dataset_id
  table_id            = "asasaki-data-infra-table"
  schema              = file("./bigquery/schema_asasaki-data-infra-table.json")
  deletion_protection = false
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "asasaki-data-infra-s3"
  acl    = "private"
}