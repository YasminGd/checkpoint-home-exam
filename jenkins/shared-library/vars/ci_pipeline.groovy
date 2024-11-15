def call(Map config = [:]) {
    // Default values if not provided
    def awsRegion = config.get('awsRegion', 'us-east-1')
    def ecrUrl = config.get('ecrUrl')
    def imageName = config.get('imageName')
    def cdJob = config.get('cdJob', 'CD')
    def microservice = config.get('microservice')
    def latestTag = '1.0.0'
    def infraImageVerProperty = "${microservice}_image_tag"

    pipeline {
        agent any
        options {
            timestamps()
            timeout(time: 15, unit: 'MINUTES')
            buildDiscarder(logRotator(numToKeepStr: '4', daysToKeepStr: '7', artifactNumToKeepStr: '30'))
        }
        environment {
            AWS_REGION = "${awsRegion}"
            ECR_URL = "${ecrUrl}"
            IMAGE_NAME = "${imageName}"
        }

        stages {
            stage('Build') {
                steps {
                    script {
                        dir("${microservice}-microservice") {
                            sh "docker build -t ${IMAGE_NAME}:latest ."
                        }
                    }
                }
            }
            stage('Login to AWS') {
                steps {
                    script {
                        sh "aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL"
                    }
                }
            }
            stage('Tag') {
                steps {
                    script {
                        latestTag = sh(script: "docker pull ${ECR_URL}/${IMAGE_NAME}:latest || true", returnStdout: true).trim()
                        
                        try {
                            latestTag = sh(
                                script: """
                                    docker images --format '{{.Tag}}' \${ECR_URL}/\${IMAGE_NAME} \
                                    | grep -E '^[0-9]+\\.[0-9]+\\.[0-9]+\$' \
                                    | sort -V \
                                    | tail -n 1
                                """, 
                                returnStdout: true
                            ).trim()
                            
                            def parts = latestTag.tokenize('.')
                            def lastDigit = (parts[-1] as int) + 1
                            latestTag = "${parts[0]}.${parts[1]}.${lastDigit}"
                        }catch (Exception e){
                            latestTag = "1.0.0"
                        }    

                        echo "Next version tag: ${latestTag}"
                        sh "docker tag ${IMAGE_NAME}:latest ${ECR_URL}/${IMAGE_NAME}:${latestTag}"
                        sh "docker tag ${IMAGE_NAME}:latest ${ECR_URL}/${IMAGE_NAME}:latest"
                    }
                }
            }
            stage('Publish') {
                steps {
                    script {
                        sh "docker push ${env.ECR_URL}/${env.IMAGE_NAME}:${latestTag}"
                        sh "docker push ${env.ECR_URL}/${env.IMAGE_NAME}:latest"
                    }
                }
            }
            stage('Deploy') {
                steps {
                    build job: cdJob,
                            parameters: [
                                string(name: 'key_to_change', value: "${infraImageVerProperty}"),
                                string(name: 'value', value: "${latestTag}")
                            ],
                            wait: false
                }
            }
        }
        post {
            always {
                sh 'docker image prune -f'
                deleteDir()
            }
            success {
                echo "CI pipeline completed successfully"
            }
            failure {
                echo "CI pipeline failed"
            }
        }
    }
}
