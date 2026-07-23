pipeline {

    agent any

    tools {
        maven 'maven'
    }

    environment {
        IMAGE_NAME     = "Webapppp"
        DOCKER_USER    = "rakshu037"
        IMAGE_TAG      = "latest"
        CONTAINER_NAME = "my-war-app"
        HOST_PORT      = "8084"
        CONTAINER_PORT = "8080"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Maven Project') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-cred-id',
                        usernameVariable: 'USERNAME',
                        passwordVariable: 'PASSWORD'
                    )
                ]) {
                    sh '''
                    echo "$PASSWORD" | docker login \
                    -u "$USERNAME" \
                    --password-stdin
                    '''
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh '''
                docker tag \
                ${IMAGE_NAME}:${IMAGE_TAG} \
                ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                docker push \
                ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker stop ${CONTAINER_NAME} || true
                docker rm ${CONTAINER_NAME} || true

                docker run -d \
                --name ${CONTAINER_NAME} \
                -p ${HOST_PORT}:${CONTAINER_PORT} \
                --restart unless-stopped \
                ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Docker Logout') {
            steps {
                sh 'docker logout'
            }
        }
    }

    post {
        always {
            echo 'Pipeline Finished'
        }
        success {
            echo 'Deployment Successful'
        }
        failure {
            echo 'Deployment Failed'
        }
    }
}
