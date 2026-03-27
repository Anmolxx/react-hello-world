pipeline {
    agent any

    environment {
        APP_NAME = "react-app"
        DOCKER_IMAGE = "react-app:latest"
        PORT = "3000"
    }

    stages {

        stage('Checkout') {
            steps {
                echo " Checking out code..."
                git branch: 'main', url: 'https://github.com/Anmolxx/react-hello-world.git'
                echo "✓ Checkout complete"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo " Building Docker image..."
                sh '''
                docker build -t ${DOCKER_IMAGE} .
                docker images | grep react-app
                '''
                echo "✓ Docker image built"
            }
        }

        stage('Stop Old Container') {
            steps {
                echo " Stopping old container (if exists)..."
                sh '''
                docker stop ${APP_NAME} || true
                docker rm ${APP_NAME} || true
                '''
            }
        }

        stage('Run Container') {
            steps {
                echo "🐳 Starting new container..."
                sh '''
                docker run -d \
                    --name ${APP_NAME} \
                    -p ${PORT}:80 \
                    --restart=unless-stopped \
                    ${DOCKER_IMAGE}
                '''
                echo "✓ Container started"
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "🔍 Verifying deployment..."
                sh '''
                sleep 5

                # Try hitting app (don’t fail pipeline if not reachable from Jenkins)
                curl -sf http://localhost:${PORT} || true

                echo "Container status:"
                docker ps | grep ${APP_NAME}
                '''
            }
        }

        stage('Summary') {
            steps {
                sh '''
                echo ""
                echo "=========================================="
                echo " DEPLOYMENT SUCCESSFUL"
                echo "=========================================="

                HOST=$(hostname -I | awk '{print $1}')

                echo "App Name: ${APP_NAME}"
                echo "Docker Image: ${DOCKER_IMAGE}"
                echo "URL: http://${HOST}:${PORT}"

                echo "=========================================="
                '''
            }
        }
    }

    post {
        failure {
            echo " Pipeline failed"
            sh '''
            docker ps -a
            docker logs ${APP_NAME} || true
            '''
        }
        success {
            echo " Pipeline succeeded"
        }
    }
}