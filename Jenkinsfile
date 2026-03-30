pipeline {
    agent any

    environment {
        APP_NAME = "react-app"
        DOCKER_IMAGE = "docker.io/anmoldeepkaur1103/react-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
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
                docker build -t docker.io/anmoldeepkaur1103/react-app:${BUILD_NUMBER} ./app
                '''
            }
        }

        stage('Docker Login & Push') {
            steps {
                echo "🚀 Logging in & pushing to Docker Hub..."

                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push $DOCKER_IMAGE:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Update Kubernetes Manifest') {
            steps {
                echo "📝 Updating deployment image..."

                sh '''
                sed -i "s|image: .*|image: $DOCKER_IMAGE:$IMAGE_TAG|g" k8s/deployment.yaml
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

                kubectl rollout status deployment react-app-deployment -n react-app
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "🔍 Verifying deployment..."

                sh '''
                kubectl get pods -n react-app -o wide
                kubectl get svc -n react-app
                '''
            }
        }

        // stage('Smoke Test') {
        //     steps {
        //         echo "🌐 Testing application..."

        //         sh '''
        //         sleep 10
        //         curl -f http://3.208.213.108:3001 || exit 1
        //         '''
        //     }
        // }

        stage('Summary') {
            steps {
                sh '''
                echo ""
                echo "=========================================="
                echo "✅ CI/CD PIPELINE EXECUTED SUCCESSFULLY"
                echo "=========================================="
                '''
            }
        }
    }

    post {
        failure {
            echo "❌ Pipeline failed - Debugging info:"

            sh '''
            echo "---- Pods ----"
            kubectl get pods -A || true

            echo "---- Describe ----"
            kubectl describe pods -n react-app || true

            echo "---- Docker ----"
            docker ps -a
            '''
        }

        success {
            echo "✅ Pipeline succeeded"
        }
    }
}