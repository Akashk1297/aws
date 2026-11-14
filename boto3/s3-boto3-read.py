import boto3

# Initialize the S3 client (uses your configured AWS credentials)
s3_client = boto3.client('s3')

# Retrieve the list of buckets
response = s3_client.list_buckets()

if response['ResponseMetadata']['HTTPStatusCode'] == 200:
    print('response from aws is successful')

    if response.get('Buckets'):
        l=len(response.get('Buckets'))
        for i in range(0,l):
            print("Existing S3 Buckets:", response['Buckets'][i]['Name'])
else:
    raise RuntimeError('response from aws not successful')
