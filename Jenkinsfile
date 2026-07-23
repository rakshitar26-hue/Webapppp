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
                echo "Building WAR..."
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker Image..."
                sh """
                sudo docker build \
                -t ${IMAGE_NAME}:${IMAGE_TAG} .
                """
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
                    echo "$PASSWORD" | sudo docker login \
                    -u "$USERNAME" \
                    --password-stdin
                    '''

                }

            }

        }

        stage('Tag Image') {

            steps {

                sh """
                sudo docker tag \
                ${IMAGE_NAME}:${IMAGE_TAG} \
                ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                """

            }

        }

        stage('Push Image') {

            steps {

                sh """
                sudo docker push \
                ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                """

            }

        }

        stage('Deploy Container') {

            steps {

                script {

                    def exists = sh(
                        script: "sudo docker ps -a --format '{{.Names}}' | grep -w ${CONTAINER_NAME} || true",
                        returnStdout: true
                    ).trim()

                    if(exists){

                        echo "Removing existing container..."

                        sh """
                        sudo docker stop ${CONTAINER_NAME} || true
                        sudo docker rm ${CONTAINER_NAME} || true
                        """

                    }

                    sh """
                    sudo docker run -d \
                    --name ${CONTAINER_NAME} \
                    -p ${HOST_PORT}:${CONTAINER_PORT} \
                    --restart unless-stopped \
                    ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                    """

                }

            }

        }

        stage('Docker Logout') {
            steps {
                sh 'sudo docker logout'
            }
        }

    }

    post {

        always {
            echo "Pipeline Finished"
        }

        success {
            echo "Deployment Successful"
        }

        failure {
            echo "Deployment Failed"
        }

    }

}
