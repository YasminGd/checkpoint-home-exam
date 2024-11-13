#!/bin/bash

cd /home/ubuntu
# deploy stack using docker-compose.yaml
docker compose --file "docker-compose.yaml" --env-file ".env" up -d --build \
|| docker-compose --file "docker-compose.yaml" --env-file ".env" up -d --build \
|| echo "docker-compose-plugin not installed" | exit 1

#-------------------------------
#Commands to run on a fresh server

# # Update package list and install dependencies
# sudo apt-get update -y
# sudo apt-get install -y docker.io
# sudo apt-get install -y docker-compose

# # Start Docker
# sudo systemctl start docker
# sudo usermod -aG docker ubuntu  # Add the 'ubuntu' user to the docker group for permissions

# # Ensure Docker starts on boot
# sudo systemctl enable docker
# #-----------------------------

# cd /home/ubuntu 

# cat << EOF > .env
# JENKINS_IMAGE=docker.io/jenkins/jenkins
# JENKINS_TAG=jdk21  # see tags here: https://hub.docker.com/r/jenkins/jenkins/tags
# HOST_DOCKER_GID=$(getent group docker | cut -d ":" -f 3)
# JENKINS_PORT=80
# EOF

# # Create Dockerfile
# cat << EOF > Dockerfile
# ARG JENKINS_IMAGE
# ARG JENKINS_TAG
# FROM ${JENKINS_IMAGE}:${JENKINS_TAG}
# COPY plugins.txt plugins.txt
# RUN jenkins-plugin-cli --plugin-file plugins.txt
# USER root
# RUN curl -fsSL https://get.docker.com | sh
# RUN usermod -aG docker jenkins
# ARG HOST_DOCKER_GID
# RUN groupmod -g "${HOST_DOCKER_GID}" docker
# #install aws
# RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# RUN unzip awscliv2.zip
# RUN ./aws/install
# #install terraform
# RUN apt-get install wget -y
# RUN apt install -y lsb-release
# RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
# RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
# RUN apt update && apt install terraform -y
# USER jenkins
# EOF

# # Create docker-compose.yaml
# cat << EOF > docker-compose.yaml
# version: "3.8"
# services:
#   jenkins:
#     hostname: jenkins
#     build:
#       context: .
#       dockerfile: Dockerfile
#       args:
#         JENKINS_IMAGE: "\${JENKINS_IMAGE}"
#         JENKINS_TAG: "\${JENKINS_TAG}"
#         HOST_DOCKER_GID: "\${HOST_DOCKER_GID}"
#     ports:
#       - "\${JENKINS_PORT}:8080"
#     volumes:
#       - "/var/run/docker.sock:/var/run/docker.sock"
#       - "jenkins_home:/var/jenkins_home"
# volumes:
#   jenkins_home:
# EOF

# touch plugins.txt

# # take down any existing deployments
# docker compose --file "docker-compose.yaml" down \
# || docker-compose --file "docker-compose.yaml" down \
# || echo "docker-compose-plugin not installed" | exit 1

# deploy stack using docker-compose.yaml
# docker compose --file "docker-compose.yaml" --env-file ".env" up -d --build \
# || docker-compose --file "docker-compose.yaml" --env-file ".env" up -d --build \
# || echo "docker-compose-plugin not installed" | exit 1