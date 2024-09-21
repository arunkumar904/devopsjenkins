pipeline {
    agent any
    
    environment {
        PROJECT_ID = 'groovy-legacy-434014-d0'  // Replace with your Google Cloud project ID
        REGION = 'us-central1'                  // Replace with your desired region
        REPO_NAME = 'my-repo'                    // Replace with your Artifact Registry repository name
        IMAGE_NAME = 'fullstack-app'            // Replace with your Docker image name
        SERVICE_ACCOUNT_KEY = 'gcp-credentials-id' // Jenkins secret ID for the service account key
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Authenticate with Google Cloud') {
            steps {
                script {
                    // Use Jenkins credentials plugin to handle service account key
                    withCredentials([file(credentialsId: SERVICE_ACCOUNT_KEY, variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                        sh 'gcloud config set project ${PROJECT_ID}'
                        sh 'gcloud auth configure-docker us-central1-docker.pkg.dev'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh 'docker build -t ${IMAGE_NAME}:latest .'
                }
            }
        }
        
        stage('Tag Docker Image') {
            steps {
                script {
                    // Tag Docker image
                    sh "docker tag ${IMAGE_NAME}:latest us-central1-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${IMAGE_NAME}:latest"
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    // Push Docker image to Google Artifact Registry
                    sh "docker push us-central1-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${IMAGE_NAME}:latest"
                }
            }
        }
        
       
        stage('Deploy to Cloud Run') {
            steps {
                script {
                    // Deploy Docker image to Google Cloud Run
                    sh "gcloud run deploy ${IMAGE_NAME} --image us-central1-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${IMAGE_NAME}:latest --region ${REGION} --platform managed --allow-unauthenticated"
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
