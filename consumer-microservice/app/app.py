import boto3
import time
from botocore.exceptions import ClientError
import os

# AWS Configurations
sqs_queue_url = os.getenv("SQS_QUEUE_URL", "test-queue-url")
s3_bucket_name = os.getenv("S3_BUCKET_NAME", "test-bucket-name")
s3_folder = os.getenv("S3_FOLDER", "default-folder") 

# Initialize AWS clients
sqs_client = boto3.client('sqs', region_name='us-east-1')
s3_client = boto3.client('s3', region_name='us-east-1')

# Function to pull messages from SQS and upload them to S3
def process_messages():
    try:
        response = sqs_client.receive_message(
            QueueUrl=sqs_queue_url,
            MaxNumberOfMessages=10,  # Adjust as necessary
            WaitTimeSeconds=10       # Long polling for new messages
        )
        
        messages = response.get('Messages', [])
        for message in messages:
            # Extract the message body
            message_body = message['Body']
            message_id = message['MessageId']

            # Create S3 file path
            s3_key = f"{s3_folder}/{message_id}.json"

            # Upload the message to S3
            s3_client.put_object(
                Bucket=s3_bucket_name,
                Key=s3_key,
                Body=message_body,
                ContentType='application/json'
            )

            # Delete the message from SQS after successful upload
            sqs_client.delete_message(
                QueueUrl=sqs_queue_url,
                ReceiptHandle=message['ReceiptHandle']
            )
            print(f"Uploaded and deleted message ID: {message_id}")

    except ClientError as e:
        print(f"Error processing messages: {e}")

if __name__ == "__main__":
    poll_interval = 30 # Set your desired polling interval in seconds
    while True:
        process_messages()
        time.sleep(poll_interval)
