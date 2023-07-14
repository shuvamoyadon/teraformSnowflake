provider "snowflake" {
  role     =  "ACCOUNTADMIN"
}

resource "snowflake_database" "example" {
  name = "EXAMPLE_DATABASE"
  comment = "A database created by terraform"
}

resource "snowflake_warehouse" "example" {
  name = "EXAMPLE_WAREHOUSE"
  warehouse_size = "X-SMALL"
  auto_suspend = 60
  auto_resume = false
  initially_suspended = true
}
