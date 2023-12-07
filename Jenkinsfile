pipeline{
    agent any
    tools {
        maven 'maven3.8.7'
        jdk 'openjdk17'
        jfrog 'jfrog-cli'
       }

    stages{
         stage('Git Checkout'){
            steps{
                git branch: "${BRANCH_NAME}", credentialsId: 'dfa41cc4-c9dc-4a68-89d6-bbefbb5c3665', url: 'https://github.com/asad059/spring-petclinic.git'
            }
        }
        stage('Run Synk Open Source Scan'){
	        steps{
	            snykSecurity(
                 snykInstallation: 'snyk@latest',
                 snykTokenId: 'organization-snyk-api-token',
                 failOnIssues: false,
                 monitorProjectOnBuild: true,
                 additionalArguments: '--all-projects --debug'
	             )
	       }
        }
        stage('Run Snyk Code Scan') {
            steps {
                snykSecurity(
                snykInstallation: 'snyk@latest',
                snykTokenId: 'organization-snyk-api-token',
                failOnIssues: false,
                monitorProjectOnBuild: false,
                additionalArguments: '--code -debug'
        )
    }
}
//         stage('Run Snyk IAC Scan') {
//             steps {
//                 snykSecurity(
//                 snykInstallation: 'snyk@latest',
//                 snykTokenId: 'organization-snyk-api-token',
//                 failOnIssues: false,
//                 monitorProjectOnBuild: true,
//                 additionalArguments: '--iac --report -d'
//         )
//     }
// }

        stage('Run Snyk container Scan') {
            steps {
                snykSecurity(
                snykInstallation: 'snyk@latest',
                snykTokenId: 'organization-snyk-api-token',
                failOnIssues: false,
                monitorProjectOnBuild: true,
                additionalArguments: '--container asad059/maven-app:1 -d'
        )
    }
}
        stage('Build'){
            steps{
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Run Sonarcloud Analysis'){
            steps{
                withCredentials([string(credentialsId: 'sonarcloud-token', variable: 'SONAR_TOKEN')]) {
                    sh "mvn sonar:sonar -Dsonar.host.url=https://sonarcloud.io/ -Dsonar.login=${SONAR_TOKEN} -Dsonar.organization=asadorg -DskipTests -Dsonar.projectKey=asadorg_petapp"
                }

            }
        }

        stage('Docker Image Build') {
            steps {
                script {
                    // Ensure Docker daemon is running
                    sh 'sudo systemctl start docker'

                    // Sleep for a few seconds to allow Docker daemon to start
                    sh 'sleep 5'

                    // Check if Docker daemon is running
                    sh 'docker info'

                    // Build Docker image
                    sh 'docker build -t asad059/petapp:${BUILD_NUMBER} .'
                    sh 'docker build -t teclops.jfrog.io/docker-local/petapp:${BUILD_NUMBER} .'
                    
                    // Check the created Docker image
                    sh 'docker images'
                }
            }
        }
        stage('push to dockerhub'){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        sh 'docker push asad059/petapp:${BUILD_NUMBER}'
                    }
                }
            }
        }

        stage('Scan and push image') {
			steps {
				
					// Scan Docker image for vulnerabilities
					jf 'docker scan teclops.jfrog.io/docker-local/petapp:${BUILD_NUMBER}'

					// Push image to Artifactory
					jf 'docker push teclops.jfrog.io/docker-local/petapp:${BUILD_NUMBER}'
				
			}
		}
		stage('Publish build info') {
			steps {
				jf 'rt build-publish'
			}
		}

    }
}
