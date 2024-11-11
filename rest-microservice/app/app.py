from flask import Flask, request, jsonify
import boto3
from botocore.exceptions import ClientError

app = Flask(__name__)

secret_name = "yasmin_checkpoint_home_exam_token"
region_name = "us-east-1"
sqs_queue_url = "https://sqs.us-east-1.amazonaws.com/YOUR_ACCOUNT_ID/YOUR_QUEUE_NAME"

session = boto3.session.Session()
secret_client = session.client(
    service_name='secretsmanager',
    region_name=region_name
)
sqs_client = session.client('sqs', region_name=region_name)

def get_secret():
    try:
        get_secret_value_response = secret_client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        raise e

    return get_secret_value_response['SecretString']

TOKEN = get_secret()

@app.route('/', methods=['POST'])
def main():
    data = request.json
    
    token = data.get("token")
    if token != TOKEN:
        return jsonify({"error": "Invalid token"}), 403
    
    payload = data.get("data", {})
    required_fields = ["email_subject", "email_sender", "email_timestream", "email_content"]
    if not all(field in payload for field in required_fields):
        return jsonify({"error": "Invalid payload structure"}), 400
    
    try:
        sqs_client.send_message(
            QueueUrl=sqs_queue_url,
            MessageBody=str(payload)  # Convert payload to string for SQS
        )
    except ClientError as e:
        return jsonify({"error": "Failed to send message to SQS", "details": str(e)}), 500
    
    return jsonify({"status": "Message sent to SQS successfully"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)