pipeline {
    agent any

    environment {
        APP_NAME = "react-app"
        IMAGE_NAME = "anmoldeepkaur1103/react-app:latest"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "📥 Checking out code..."
                git branch: 'main', url: 'https://github.com/Anmolxx/react-hello-world.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🔨 Building Docker image..."
                sh '''
                docker build -t ${IMAGE_NAME} .
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "🚀 Pushing image to Docker Hub..."
                sh '''
                docker push ${IMAGE_NAME}
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "☸️ Deploying to Kubernetes..."

                sh '''
                kubectl apply -f k8s/namespace.yaml || true
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml
                kubectl apply -f k8s/fluent-bit.yaml

                kubectl rollout restart deployment react-app-deployment -n react-app
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "🔍 Verifying pods..."
                sh '''
                kubectl get pods -n react-app
                kubectl get svc -n react-app
                '''
            }
        }

        stage('Summary') {
            steps {
                sh '''
                echo ""
                echo "=========================================="
                echo "✅ KUBERNETES DEPLOYMENT SUCCESSFUL"
                echo "=========================================="
                '''
            }
        }
    }

    post {
        failure {
            echo "❌ Pipeline failed"
            sh '''
            kubectl get pods -A || true
            docker ps -a
            '''
        }
        success {
            echo "✅ Pipeline succeeded"
        }
    }
}