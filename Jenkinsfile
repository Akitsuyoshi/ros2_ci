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

        stage('Cleanup') {
            steps {
                sh 'docker-compose down'
            }
        }
        stage('Done') {
            steps {
                sleep 5
                echo 'Pipeline completed'
            }
        }
    }
}