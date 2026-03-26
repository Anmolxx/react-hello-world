pipeline {
    agent any

    environment {
        APP_NAME = "react-app"
        DOCKER_IMAGE = "react-app:latest"
        DOCKER_REGISTRY = "localhost:5000"
        NAMESPACE = "default"
        REPLICAS = "2"
        PORT = "3000"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "📥 Checking out code from main branch..."
                git branch: 'main', url: 'https://github.com/Anmolxx/react-hello-world.git'
                echo "✓ Checkout complete"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🔨 Building Docker image: ${DOCKER_IMAGE}"
                sh '''
                docker build -t ${DOCKER_IMAGE} .
                echo "✓ Docker image built successfully"
                docker images | grep react-app
                '''
            }
        }

        stage('Load Image to Kind') {
            steps {
                echo "📦 Loading image into kind cluster..."
                sh '''
                # Check if kind cluster exists
                if kind get clusters | grep -q "devops-cluster"; then
                    echo "✓ Kind cluster 'devops-cluster' found"
                    
                    # Load the image into kind
                    kind load docker-image ${DOCKER_IMAGE} --name devops-cluster
                    echo "✓ Image loaded to kind cluster"
                else
                    echo "⚠️  Kind cluster not found, will run as Docker container"
                fi
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "🚀 Deploying to Kubernetes..."
                sh '''
                # Check if kubectl is available
                if command -v kubectl >/dev/null 2>&1; then
                    echo "Kubectl found, attempting K8s deployment..."
                    
                    # Create deployment if it doesn't exist
                    if ! kubectl get deployment ${APP_NAME} -n ${NAMESPACE} 2>/dev/null; then
                        echo "Creating deployment..."
                        kubectl create deployment ${APP_NAME} \
                            --image=${DOCKER_IMAGE} \
                            --replicas=${REPLICAS} \
                            -n ${NAMESPACE}
                        
                        # Expose the deployment
                        echo "Exposing service..."
                        kubectl expose deployment ${APP_NAME} \
                            --type=LoadBalancer \
                            --port=80 \
                            --target-port=80 \
                            --name=${APP_NAME}-service \
                            -n ${NAMESPACE} || true
                    else
                        echo "Updating existing deployment..."
                        kubectl set image deployment/${APP_NAME} \
                            ${APP_NAME}=${DOCKER_IMAGE} \
                            -n ${NAMESPACE}
                    fi
                    
                    # Show deployment status
                    echo "Deployment status:"
                    kubectl get deployment ${APP_NAME} -n ${NAMESPACE}
                    kubectl get pods -n ${NAMESPACE} -l app=${APP_NAME}
                    
                    echo "✓ Kubernetes deployment complete"
                else
                    echo "Kubectl not available, skipping K8s deployment"
                fi
                '''
            }
        }

        stage('Fallback: Docker Direct') {
            steps {
                echo "🐳 Running as Docker container (fallback)..."
                sh '''
                # Only run direct Docker if kubectl is not available
                if ! command -v kubectl >/dev/null 2>&1; then
                    echo "Running Docker container directly..."
                    
                    # Stop old container if exists
                    docker stop ${APP_NAME} || true
                    docker rm ${APP_NAME} || true
                    
                    # Run new container
                    docker run -d \
                        --name ${APP_NAME} \
                        -p ${PORT}:80 \
                        --restart=unless-stopped \
                        ${DOCKER_IMAGE}
                    
                    echo "✓ Container running"
                fi
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "🔍 Verifying deployment..."
                sh '''
                # Wait for app to be ready
                echo "Waiting for application to be ready (max 2 minutes)..."
                
                max_attempts=24
                attempt=0
                
                while [ $attempt -lt $max_attempts ]; do
                    # Try kubectl port-forward first
                    if command -v kubectl >/dev/null 2>&1; then
                        kubectl port-forward -n ${NAMESPACE} \
                            $(kubectl get pod -n ${NAMESPACE} -l app=${APP_NAME} -o jsonpath='{.items[0].metadata.name}' 2>/dev/null) \
                            ${PORT}:80 2>/dev/null &
                        PF_PID=$!
                        sleep 2
                        
                        if curl -sf http://localhost:${PORT} >/dev/null 2>&1; then
                            kill $PF_PID 2>/dev/null || true
                            echo "✓ Application is running and responding"
                            break
                        fi
                        kill $PF_PID 2>/dev/null || true
                    fi
                    
                    # Try direct Docker access
                    if curl -sf http://localhost:${PORT} >/dev/null 2>&1; then
                        echo "✓ Application is running and responding"
                        break
                    fi
                    
                    attempt=$((attempt + 1))
                    if [ $attempt -lt $max_attempts ]; then
                        echo "  Attempt $attempt/$max_attempts... waiting..."
                        sleep 5
                    fi
                done
                
                if [ $attempt -eq $max_attempts ]; then
                    echo "⚠️  Application did not respond within timeout"
                    
                    # Show debug info
                    echo "Debug Info:"
                    docker ps -a | grep react
                    if command -v kubectl >/dev/null 2>&1; then
                        kubectl get pods -n ${NAMESPACE}
                        kubectl logs -n ${NAMESPACE} -l app=${APP_NAME} --tail=20 || true
                    fi
                    exit 1
                fi
                '''
            }
        }

        stage('Summary') {
            steps {
                echo "✅ BUILD AND DEPLOYMENT COMPLETE"
                sh '''
                echo ""
                echo "=========================================="
                echo "Deployment Summary"
                echo "=========================================="
                echo "Application: ${APP_NAME}"
                echo "Docker Image: ${DOCKER_IMAGE}"
                echo "Port: ${PORT}"
                
                if command -v kubectl >/dev/null 2>&1; then
                    echo ""
                    echo "Kubernetes Details:"
                    echo "  Cluster: devops-cluster"
                    echo "  Namespace: ${NAMESPACE}"
                    echo "  Replicas: ${REPLICAS}"
                    kubectl get deployment ${APP_NAME} -n ${NAMESPACE} || echo "  (K8s deployment)"
                    kubectl get pods -n ${NAMESPACE} -l app=${APP_NAME} || echo "  (K8s pods)"
                else
                    echo ""
                    echo "Running as Docker container:"
                    docker ps | grep ${APP_NAME}
                fi
                
                echo ""
                echo "Access Application:"
                HOSTNAME=$(hostname -I | awk '{print $1}')
                echo "  http://${HOSTNAME}:${PORT}"
                echo ""
                echo "=========================================="
                '''
            }
        }
    }

    post {
        failure {
            echo "❌ Pipeline failed!"
            sh '''
            echo "Build failed. Debug information:"
            docker ps -a
            docker logs ${APP_NAME} 2>/dev/null || true
            if command -v kubectl >/dev/null 2>&1; then
                kubectl get all -n ${NAMESPACE}
                kubectl logs -n ${NAMESPACE} -l app=${APP_NAME} 2>/dev/null || true
            fi
            '''
        }
        success {
            echo "✅ Pipeline succeeded!"
        }
    }
}
