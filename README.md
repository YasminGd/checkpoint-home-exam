
# Read Me

This is my home assignment for checkpoint, It has two main main parts: an ecs cluster with the microservices and a jenkins machine to perform ci/cd.

# Folder Structure
**rest-microservice** - contains the source code for the rest microservice, Dockerfile, Jenkinsfile, and a requirements.txt. 
It's role is to receive post requests from an elb, verify the token that came with the request (match it up with a token in aws secret manager), make sure the request is formatted correctly and send the requests to an sqs if everything is in order.

connects with:
* AWS Secret Manager 
* AWS SQS

To build just use the docker command
```bash
docker build -t rest-microservice .
```
Or in the app folder create a venv, install requirements and run the app as python
 ```bash
cd app
python3 -m venv venv
source venv/bin/activate
pip install -r ../requirements.txt
python app.py
```

**consumer-microservice** - contains the source code for the consumer microservice, Dockerfile, Jenkinsfile, and a requirements.txt. 
It's role is to pool messages from the sqs and pass them into a s3 bucket for.

connects with:
* AWS SQS
* AWS S3

To build just use the docker command
```bash
docker build -t rest-microservice .
```
Or in the app folder create a venv, install requirements and run the app as python
 ```bash
cd app
python3 -m venv venv
source venv/bin/activate
pip install -r ../requirements.txt
python app.py
```
**jenkins** - contains the cd pipeline and a shared library. Use by configuring a Jenkins server to run the pipeline by linking the pipeline's Jenkinsfiles and shared library to the designated repository and folder.
CI pipeline - build the docker image, tags it, pushes it into ecr and triggers the CD pipline
CD pipeline - updates the microservice version in ``terraform/terraform.tfvars`` and, updates the environment and pushes the changes back to git.

**jenkins-terraform** - Contains the terrafrom files for the jenkins server. modules include compute (ec2), networking, and security.
Run by changing the values in terraform.tfvars to what you need using terraform commands.
 ```bash
terraform apply
```
Then you can access jenkins with ```http://IP_OF_EC2```
username and password are both admin
**If Jenkins runs slowly go to Manage Jenkins -> System -> Jenkins URL and change the value to the current ec2 url, that should fix that issue**

⚠️ **Warning** - state is stored in a pre-existing s3 bucket and locked by a pre-existing dynamoDB table. either create them seperately before running terrafrom apply or use the remote-state module in the folder. Change the names in `modules/remote-state/main.tf` to what you need and make sure that the backend names match in `providers.tf`

Run by using these commands in `modules/remote-state`:
```bash
terraform init
terraform apply
```
**terraform** - Contains the terrafrom files for the environment. modules include compute (ecs,ecr,sqs,s3) , networking, and security.
Run by changing the values in terraform.tfvars to what you need using terraform commands.
 ```bash
terraform apply
```
⚠️ **Warning** - state is stored in a pre-existing s3 bucket and locked by a pre-existing dynamoDB table. either create them seperately before running terrafrom apply or use the remote-state module in the folder. Change the names in `modules/remote-state/main.tf` to what you need and make sure that the backend names match in `providers.tf`

Run by using these commands in `modules/remote-state`:
```bash
terraform init
terraform apply
```
# Important Note
The token that gets pulled by the rest microservice from AWS secret manager is the only thing that doesn't get created by terraform due to security reasons.
You have to create it manually BEFORE using ``teraform apply`` and save it's arn in ```terraform/terraform.tfvars```.
