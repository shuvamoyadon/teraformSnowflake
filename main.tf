terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.25.17"
    }
  }
}

provider "snowflake" {
  account  = "eg42130" # the Snowflake account identifier
  username = "aditi007"
  password = "Iamhere1"
  region = "us-east-2.aws"
  role = "ACCOUNTADMIN"
}

resource "snowflake_database" "demo_db" {
  name    = "mydb"
  comment = "Database for Snowflake Terraform demo"
}