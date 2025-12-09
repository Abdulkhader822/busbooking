pipeline {
    agent any
    
    environment {
        DOCKERHUB_USERNAME = 'YOUR_DOCKERHUB_USERNAME'  // Change this
        DOCKERHUB_PASSWORD = 'YOUR_DOCKERHUB_PASSWORD'  // Change this
        BACKEND_IMAGE = "${DOCKERHUB_USERNAME}/routebuddy-backend"
        FRONTEND_IMAGE = "${DOCKERHUB_USERNAME}/routebuddy-frontend"
        GITHUB_REPO = 'https://github.com/YOUR_USERNAME/BusBookingRouteBuddy.git'  // Change this
        AZURE_VM_HOST = 'YOUR_VM_IP_OR_DNS'  // Change this
        AZURE_VM_USER = 'azureuser'  // Change if different
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                echo '📥 Fetching code from GitHub...'
                git branch: 'main', url: "${GITHUB_REPO}"
            }
        }
        
        stage('Build Backend Docker Image') {
            steps {
                echo '🔨 Building Backend Docker Image...'
                dir('backend') {
                    script {
                        sh "docker build -t ${BACKEND_IMAGE}:${BUILD_NUMBER} -t ${BACKEND_IMAGE}:latest ."
                    }
                }
            }
        }
        
        stage('Build Frontend Docker Image') {
            steps {
                echo '🔨 Building Frontend Docker Image...'
                dir('frontend/routebuddy') {
                    script {
                        sh "docker build -t ${FRONTEND_IMAGE}:${BUILD_NUMBER} -t ${FRONTEND_IMAGE}:latest ."
                    }
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                echo '📤 Pushing images to Docker Hub...'
                script {
                    sh '''
                        echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin
                        docker push ${BACKEND_IMAGE}:${BUILD_NUMBER}
                        docker push ${BACKEND_IMAGE}:latest
                        docker push ${FRONTEND_IMAGE}:${BUILD_NUMBER}
                        docker push ${FRONTEND_IMAGE}:latest
                    '''
                }
            }
        }
        
        stage('Deploy to Azure VM') {
            steps {
                echo '🚀 Deploying to Azure VM...'
                script {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ${AZURE_VM_USER}@${AZURE_VM_HOST} << EOF
echo "Logging into Docker Hub..."
echo ${DOCKERHUB_PASSWORD} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin

echo "Stopping existing containers..."
docker stop routebuddy-backend routebuddy-frontend || true
docker rm routebuddy-backend routebuddy-frontend || true

echo "Pulling latest images..."
docker pull ${BACKEND_IMAGE}:latest
docker pull ${FRONTEND_IMAGE}:latest

echo "Starting Backend container..."
docker run -d --name routebuddy-backend \\
  -p 5000:80 \\
  -e ASPNETCORE_ENVIRONMENT=Production \\
  --restart unless-stopped \\
  ${BACKEND_IMAGE}:latest

echo "Starting Frontend container..."
docker run -d --name routebuddy-frontend \\
  -p 80:80 \\
  --restart unless-stopped \\
  ${FRONTEND_IMAGE}:latest

echo "Cleaning up old images..."
docker image prune -f

docker logout
EOF
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ Deployment Successful!'
            echo "Backend API: http://${AZURE_VM_HOST}:5000"
            echo "Frontend: http://${AZURE_VM_HOST}"
        }
        failure {
            echo '❌ Deployment Failed!'
        }
        always {
            sh 'docker logout || true'
            echo '🧹 Cleaning up workspace...'
        }
    }
}
