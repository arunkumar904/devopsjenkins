pipeline {
    agent any

    environment {
        PROJECT_ID = 'groovy-legacy-434014-d0'          // Your Google Cloud project ID
        REGION = 'us-central1'                        // Your region
        REPO_NAME = 'my-repo'                          // Your Artifact Registry repository name
        IMAGE_NAME = 'fullstack-app'                   // Your Docker image name
        SERVICE_ACCOUNT_KEY = credentials('gcp-credentials-id')  // Jenkins credential ID
        DOCKER_IMAGE_TAG = "us-central1-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${IMAGE_NAME}:${env.BUILD_ID}"
    }

    stages {
        stage('Install Frontend Dependencies') {
            steps {
                dir('frontend') {
                    echo 'Installing frontend dependencies...'
                    sh 'npm install'
                }
            }
        }

        stage('Install Backend Dependencies') {
            steps {
                dir('backend') {
                    echo 'Installing backend dependencies...'
                    sh 'pip install -r requirements.txt'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh """
                    docker build -t ${DOCKER_IMAGE_TAG} .
                """
            }
        }

        stage('Authenticate with GCP') {
            steps {
                echo 'Authenticating with Google Cloud...'
                sh """
                    echo "${SERVICE_ACCOUNT_KEY}" | gcloud auth activate-service-account --key-file=-
                    gcloud auth configure-docker us-central1-docker.pkg.dev
                """
            }
        }

        stage('Push Docker Image to Artifact Registry') {
            steps {
                echo 'Pushing Docker image to Google Artifact Registry...'
                sh """
                    docker push ${DOCKER_IMAGE_TAG}
                """
            }
        }

        stage('Deploy to Cloud Run') {
            steps {
                echo 'Deploying to Cloud Run...'
                sh """
                    gcloud run deploy ${IMAGE_NAME}-service \
                        --image ${DOCKER_IMAGE_TAG} \
                        --platform managed \
                        --region ${REGION} \
                        --allow-unauthenticated \
                        --service-account my-service-account@${PROJECT_ID}.iam.gserviceaccount.com
                """
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}
