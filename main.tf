terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.25.17"
    }
  }
}

provider "snowflake" {
  role = "ACCOUNTADMIN"
}

resource "snowflake_database" "demo_db" {
  name    = "mydb"
  comment = "Database for Snowflake Terraform demo"
}