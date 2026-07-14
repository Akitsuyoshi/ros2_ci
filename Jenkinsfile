pipeline {
    agent any 
    stages {
        stage('Print and list current directory') {
            steps {
                sh 'pwd'
                sh 'ls -al'
            }
        }
        stage('Show ROS environment variables') {
            steps {
                sh 'env | grep ROS'
            }
        }
        stage('Pull Image') {
            steps {
                sh 'docker-compose pull'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'docker-compose up --abort-on-container-exit --exit-code-from ros2_ci'
            }
        }
    }
    post {
        always {
            echo 'Cleaning up Docker containers...'
            sh 'docker-compose down'
        }
        success {
            echo 'Tests passed!'
        }
        failure {
            echo 'Tests failed!'
        }
    }
}