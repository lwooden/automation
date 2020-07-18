import boto3
region = "us-east-1"


db3 = 'hsp-test-database'    

def lambda_handler(event, context):
    RDS = boto3.client("rds",region_name=region)
    responseOne = RDS.start_db_instance(DBInstanceIdentifier=db3)

