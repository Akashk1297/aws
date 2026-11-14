import logging
import boto3
from botocore.exceptions import ClientError
local_file_path='E:\\gitHub\\abc.log'
bucket_name='akkundu-s3-bucket-1'
s3_object_key='folder1/abc.log'

def upload_to_s3(local_file_path, bucket_name, s3_object_key):
    s3_client = boto3.client('s3')
    try:
        response=s3_client.upload_file(local_file_path, bucket_name, s3_object_key)
        if response["ResponseMetadata"]["HTTPStatusCode"] == 200:
            print("Upload successful.")
        else:
            print("Delete NOT successful. Return code: ",response["ResponseMetadata"]["HTTPStatusCode"])
    except ClientError as e:
        logging.error(e)

# Example usage
upload_to_s3(local_file_path,bucket_name,s3_object_key)
