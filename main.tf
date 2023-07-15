terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.25.17"
    }
  }
}

provider "snowflake" {
  account                = "eg42130" 
  username               = "aditi007"
  password               = "Iamhere1"
  role                   = "ACCOUNTADMIN"
  region                 = "us-east-2"
}

resource "snowflake_database" "demo_db" {
  name    = "mydb"
  comment = "Database for Snowflake Terraform demo"
}