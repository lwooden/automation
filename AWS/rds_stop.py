import boto3
region = "us-east-1"


databases = ["hsp-prod-database","hsp-prod-database-2","hsp-test-database"]

def lambda_handler(event, context):
    
    RDS = boto3.client("rds",region_name=region)
    
    for database in databases:
        
        try:
            RDS.stop_db_instance(DBInstanceIdentifier=database)
        except:
            print(database + " is already stopped! Trying the next one")
        else:
            print("Stopping " + database)
    
    print("Finished!")
