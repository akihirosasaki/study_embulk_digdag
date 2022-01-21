# s3, bigqueryの環境構成を指定
resource "google_compute_network" "private_network" {
  name = "private-network"
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.private_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "postgres" {
  name = "digdagv1"
  database_version = "POSTGRES_11"
  region = "us-central1"
  depends_on = [google_service_networking_connection.private_vpc_connection]
  settings {
    tier = "db-f1-micro"
    availability_type = "ZONAL"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.id
    }
    backup_configuration {
      enabled = false
    }
  }
  deletion_protection = false
}

resource "google_sql_database" "database" {
  name = var.DB_NAME
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "users" {
  name = var.DB_USER
  depends_on = [google_sql_database_instance.postgres]
  instance = google_sql_database_instance.postgres.name
  password = var.DB_USER_PASSWORD
}

resource "google_vpc_access_connector" "vpc_connector" {
  name = "digdag-connector"
  ip_cidr_range = "10.14.0.0/28"
  network = google_compute_network.private_network.name
}

# resource "google_cloud_run_service" "service" {
#   name = "service"
#   location = "us-central1"
#   template {
    
#   }
#   metadata {
#     annotations = {
#       "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.vpc_connector.name
#       "run.googleapis.com/vpc-access-egress" = "private-ranges-only"
#     }
#   }
# }


resource "google_bigquery_dataset" "bigquery_dataset" {
  dataset_id    = "asasaki_data_infra_dataset"
  friendly_name = "asasaki_data_infra_dataset"
  location      = "us-central1"
}

resource "google_bigquery_table" "bigquery_table" {
  dataset_id          = google_bigquery_dataset.bigquery_dataset.dataset_id
  table_id            = "asasaki_data_infra_table"
  schema              = file("/tmp/bigquery/schema_asasaki-data-infra-table.json")
  deletion_protection = false
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "asasaki-data-infra-s3"
  acl    = "private"
}