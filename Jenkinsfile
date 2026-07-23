pipeline {
    agent any

    tools {
        maven 'maven'
    }

    environment {
        IMAGE_NAME = "webapp"
        DOCKER_USER = "rakshu037"
        CONTAINER_NAME = "webapp-war-container"
    }

    stages {

        stage('Build') {
            steps {
                echo "Building the project..."
                sh 'mvn clean package'
            }
            post {
                success {
                    echo 'Build completed successfully.'
                }
                failure {
                    echo 'Build failed.'
                }
            }
        }

        stage('Docker Build Image') {
            steps {
                echo "Building Docker Image..."
                sh 'sudo docker build -t $IMAGE_NAME .'
            }
            post {
                success {
                    echo 'Docker image built successfully.'
                }
                failure {
                    echo 'Docker image build failed.'
                }
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-cred-id',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                    echo "$PASS" | sudo docker login -u "$USER" --password-stdin
                    '''
                }
            }
        }

        stage('Docker Tag Image') {
            steps {
                sh '''
                sudo docker tag $IMAGE_NAME $DOCKER_USER/$IMAGE_NAME:latest
                '''
            }
        }

        stage('Docker Push Image') {
            steps {
                sh '''
                sudo docker push $DOCKER_USER/$IMAGE_NAME:latest
                '''
            }
        }

        stage('Cleanup Local Images') {
            steps {
                sh '''
                sudo docker rmi $DOCKER_USER/$IMAGE_NAME:latest || true
                sudo docker rmi $IMAGE_NAME || true
                '''
            }
        }

        stage('Run Docker Container') {
            steps {
                script {

                    def exists = sh(
                        script: "sudo docker ps -a --format '{{.Names}}' | grep -w ${CONTAINER_NAME} || true",
                        returnStdout: true
                    ).trim()

                    if (exists) {

                        echo "Container already exists."

                        def choice = input(
                            id: 'RestartContainer',
                            message: 'Container already exists. Redeploy?',
                            parameters: [
                                choice(
                                    name: 'ACTION',
                                    choices: ['Yes', 'No'],
                                    description: 'Choose'
                                )
                            ]
                        )

                        if(choice == 'Yes') {

                            sh """
                            sudo docker stop ${CONTAINER_NAME} || true
                            sudo docker rm ${CONTAINER_NAME} || true

                            sudo docker run -d \
                            --name ${CONTAINER_NAME} \
                            -p 8084:8080 \
                            ${DOCKER_USER}/${IMAGE_NAME}:latest
                            """

                        } else {

                            echo "Deployment skipped."

                        }

                    } else {

                        sh """
                        sudo docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p 8084:8080 \
                        ${DOCKER_USER}/${IMAGE_NAME}:latest
                        """

                    }

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
            echo "Pipeline Finished."
        }

        success {
            echo "Pipeline Executed Successfully."
        }

        failure {
            echo "Pipeline Failed."
        }

    }

}
