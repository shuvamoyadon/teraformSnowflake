from datetime import datetime
from airflow import DAG
from airflow.providers.microsoft.mssql.operators.mssql import MsSqlOperator

# Define your SQL Server 
sql_conn_id = "sqlconn"


default_args = {
    "owner": "airflow",
    "start_date": datetime(2023, 7, 18),
}

dag = DAG(
    "mssql_to_snowflake",
    default_args=default_args,
    schedule_interval="@once",
)

# Define your SQL Server query to get the data
sql_query = "SELECT * FROM mydbs.dbo.test"

# Define your sqlserver loading query
out_query = "INSERT INTO mydbs.dbo.test1 VALUES (%s)"

# Get data from SQL Server
get_data = MsSqlOperator(
    task_id="get_data",
    mssql_conn_id=sql_conn_id,
    sql=sql_query,
    dag=dag,
)

# Load data into sqlserver table
load_data = MsSqlOperator(
    task_id="load_data",
    mssql_conn_id=sql_conn_id,
    sql=out_query,
    parameters=get_data.output, # Pass the output of the previous task
    dag=dag,
)

# Define the order of the tasks
get_data >> load_data



############

from datetime import datetime
from airflow import DAG
from airflow.providers.microsoft.mssql.operators.mssql import MsSqlOperator
from airflow.providers.amazon.aws.hooks.s3 import S3Hook
from airflow.operators.python import PythonOperator

# Define your SQL Server 
sql_conn_id = "sqlconn"
s3_bucket = "your-s3-bucket"
s3_key = "temp_data.csv"

default_args = {
    "owner": "airflow",
    "start_date": datetime(2023, 7, 18),
}

dag = DAG(
    "mssql_to_snowflake",
    default_args=default_args,
    schedule_interval="@once",
)

# Define your SQL Server query to get the data
sql_query = "SELECT * FROM mydbs.dbo.test"

def upload_to_s3(data, filename, bucket_name, replace):
    hook = S3Hook(aws_conn_id='aws_default')
    hook.load_string(
        string_data=data,
        key=s3_key,
        bucket_name=s3_bucket,
        replace=replace
    )

# Get data from SQL Server and store it in S3
get_data = MsSqlOperator(
    task_id="get_data",
    mssql_conn_id=sql_conn_id,
    sql=sql_query,
    dag=dag,
)

upload_data_to_s3 = PythonOperator(
    task_id='upload_data_to_s3',
    python_callable=upload_to_s3,
    op_args=[get_data.output, s3_key, s3_bucket, True],
    dag=dag
)

# Define your SQL Server loading query
out_query = "INSERT INTO mydbs.dbo.test1 VALUES (%s)"

def download_from_s3(bucket_name, key):
    hook = S3Hook(aws_conn_id='aws_default')
    data = hook.read_key(
        key=key,
        bucket_name=bucket_name
    )
    return data

download_data_from_s3 = PythonOperator(
    task_id='download_data_from_s3',
    python_callable=download_from_s3,
    op_args=[s3_bucket, s3_key],
    dag=dag
)

# Load data into SQL Server table from S3
load_data = MsSqlOperator(
    task_id="load_data",
    mssql_conn_id=sql_conn_id,
    sql=out_query,
    parameters=download_data_from_s3.output,
    dag=dag,
)

# Define the order of the tasks
get_data >> upload_data_to_s3 >> download_data_from_s3 >> load_data
