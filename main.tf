terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.25.17"
    }
  }

  backend "remote" {
    organization = "myteraformcloud"

    workspaces {
      name = "workspace1"
    }
  }
}

provider "snowflake" {
}

resource "snowflake_database" "demo_db" {
  name    = "mydb"
  comment = "Database for Snowflake Terraform demo"
}