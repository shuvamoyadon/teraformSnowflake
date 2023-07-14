terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.61"
    }
  }
}

provider "snowflake" {
  account  = "eg42130"
  region   = "us-east-2.aws"
  username = "ADITI007"
  password = "Iamhere1"
  role     = "ACCOUNTADMIN"
}

resource "snowflake_database" "example" {
  name = "mydb"
  comment = "A database created by terraform"
}

resource "snowflake_warehouse" "example" {
  name = "COMPUTE_WH"
  warehouse_size = "SMALL"
  auto_suspend = 70
  auto_resume = false
  initially_suspended = true
}
