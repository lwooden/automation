import json
import boto3

def lambda_handler(event, context):

   ec2 = boto3.client('ec2', region_name='us-east-1')
   result = ec2.describe_volumes( Filters=[{'Name': 'status', 'Values': ['in-use']}])
   print(result['Volumes'][0]['VolumeId'])
        
   for volume in result['Volumes']:
      
      # if volume['VolumeId'] == 'vol-02268c88b20cddc14':
         result = ec2.create_snapshot(VolumeId=volume['VolumeId'],Description='Snapshot taken by Lambda')
         
         print(result) # check result object
         
         ec2resource = boto3.resource('ec2', region_name='us-east-1')
         snapshot = ec2resource.Snapshot(result['SnapshotId']) # pass return object from createSnapshot to resource and grab SnapshotId
        
         volumeName = 'null'
         if 'Tags' in volume: # Grab name tag for the current volume
             for tags in volume['Tags']:
                if tags["Key"] == 'Name':
                        volumeName = tags["Value"]
        
         snapshot.create_tags(Tags=[{'Key': 'Name','Value': volumeName}]) # tag on name to new snapshot resource
      # else:
      #    result = ec2.create_snapshot(VolumeId=volume['VolumeId'],Description='Snapshot by Lambda')
