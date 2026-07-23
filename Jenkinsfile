pipeline {
    agent any

    tools {
        maven 'maven'
    }

    stages {

        stage('Build') {
            steps {
                echo "Building the project..."
                sh 'mvn clean package'
            }
        }

        stage('Docker Build Image') {
            steps {
                sh 'sudo docker build -t Webapppp .'
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
                sh 'sudo docker tag Webapppp rakshitar26-hue/Webapppp:latest'
            }
        }

        stage('Docker Push Image') {
            steps {
                sh 'sudo docker push rakshitar26-hue/Webapppp:latest'
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''
                    sudo docker stop webapppp-container || true
                    sudo docker rm webapppp-container || true
                    sudo docker run -d -p 8084:80 --name webapppp-container rakshitar26-hue/Webapppp:latest
                '''
            }
        }

        stage('Cleanup') {
            steps {
                sh '''
                    sudo docker logout
                    sudo docker rmi rakshitar26-hue/Webapppp:latest || true
                    sudo docker rmi Webapppp || true
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully.'
        }
        failure {
            echo 'Pipeline failed.'
        }
        always {
            echo 'Pipeline execution completed.'
        }
    }
}
