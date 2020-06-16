import json
import boto3

region = "us-east-1"
instanceList = []
  
def lambda_handler(event, context):

  ec2 = boto3.resource("ec2")
  ec2client = boto3.client("ec2")

  for instance in ec2.instances.all():
    instanceList.append(instance.id)
    
  print(instanceList)
  instanceList.remove("i-08317ea05c90faf3d")
  instanceList.remove("i-08259eca31633c0e3")
  print(instanceList)

  for node in instanceList:
    print("Starting instance: " + str(node))

 
  ec2client.start_instances(InstanceIds=instanceList)