terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.61"
    }
  }
}

provider "snowflake" {

  role     =  "ACCOUNTADMIN"

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
