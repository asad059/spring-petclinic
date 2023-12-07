pipeline {
    agent any

    tools {
        maven 'maven3.8.7'
        jdk 'openjdk17'
    }

    stages {
        stage('Check out') {
            steps {
                git branch: "${BRANCH_NAME}", credentialsId: 'dfa41cc4-c9dc-4a68-89d6-bbefbb5c3665', url: 'https://github.com/asad059/spring-petclinic.git'
            }
        }

        stage('Build') {
            steps {
                sh "mvn clean package -DskipTests"
            }
        }
    }
}
