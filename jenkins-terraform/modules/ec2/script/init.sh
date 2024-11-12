#!/bin/bash
# Update package list and install dependencies
sudo apt-get update -y
sudo apt-get install -y docker.io
sudo apt-get install -y docker-compose

# Start Docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu  # Add the 'ubuntu' user to the docker group for permissions

# sudo mkdir -p $(pwd)/jenkins_home

# sudo chown -R 1000:1000 $(pwd)/jenkins_home
# sudo chmod -R 777 $(pwd)/jenkins_home


# Pull and run Jenkins Docker container
# sudo docker run -d --name jenkins -p 80:8080 -p 50000:50000 \
# -v $(pwd)/jenkins_home:/var/jenkins_home \
# jenkins/jenkins:jdk21

# Ensure Docker starts on boot
sudo systemctl enable docker

#-----------------------------

cd /home/ubuntu 

cat << EOF > .env
JENKINS_IMAGE=docker.io/jenkins/jenkins
JENKINS_TAG=jdk21  # see tags here: https://hub.docker.com/r/jenkins/jenkins/tags
HOST_DOCKER_GID=$(getent group docker | cut -d ":" -f 3)
JENKINS_PORT=80
EOF

# Create Dockerfile
cat << EOF > Dockerfile
ARG JENKINS_IMAGE
ARG JENKINS_TAG
FROM \${JENKINS_IMAGE}:\${JENKINS_TAG}
COPY plugins.txt plugins.txt
RUN jenkins-plugin-cli --plugin-file plugins.txt
USER root
RUN curl -fsSL https://get.docker.com | sh
RUN usermod -aG docker jenkins
ARG HOST_DOCKER_GID
RUN groupmod -g "\${HOST_DOCKER_GID}" docker
USER jenkins
EOF

# Create docker-compose.yaml
cat << EOF > docker-compose.yaml
version: "3.8"
services:
  jenkins:
    hostname: jenkins
    build:
      context: .
      dockerfile: Dockerfile
      args:
        JENKINS_IMAGE: "\${JENKINS_IMAGE}"
        JENKINS_TAG: "\${JENKINS_TAG}"
        HOST_DOCKER_GID: "\${HOST_DOCKER_GID}"
    ports:
      - "\${JENKINS_PORT}:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
      - "jenkins_home:/var/jenkins_home"
volumes:
  jenkins_home:
EOF

touch plugins.txt

# take down any existing deployments
docker compose --file "docker-compose.yaml" down \
|| docker-compose --file "docker-compose.yaml" down \
|| echo "docker-compose-plugin not installed" | exit 1

# deploy stack using docker-compose.yaml
docker compose --file "docker-compose.yaml" --env-file ".env" up -d --build \
|| docker-compose --file "docker-compose.yaml" --env-file ".env" up -d --build \
|| echo "docker-compose-plugin not installed" | exit 1

