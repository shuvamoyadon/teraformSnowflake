provider "snowflake" {
  account  = "eg42130" # the Snowflake account identifier
  username = "aditi007"
  password = "Iamhere1"
  role = "ACCOUNTADMIN"
}

resource "snowflake_database" "demo_db" {
  name    = "mydb"
  comment = "Database for Snowflake Terraform demo"
}