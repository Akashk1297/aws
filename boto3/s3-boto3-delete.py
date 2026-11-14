import boto3
bucket_name='akkundu-s3-bucket-2'
s3_object_key='CBSE-Maths-Book-Class6-Sarah.pdf'

try:
    s3=boto3.client('s3')
    response=s3.delete_object(Key=s3_object_key,Bucket=bucket_name)
    print(response)
    if response["ResponseMetadata"]["HTTPStatusCode"] == 200:
        print("Delete successful.")
    else:
        print("Delete NOT successful. Return code: ",response["ResponseMetadata"]["HTTPStatusCode"])
except RuntimeError:
    print('Caught runtime error')
