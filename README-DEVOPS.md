# Complete End-to-End DevOps Project

A production-ready DevOps environment with container-first architecture including infrastructure-as-code, CI/CD pipeline, Kubernetes orchestration, and centralized logging.

## Project Overview

This project demonstrates a complete DevOps workflow:

1. **Infrastructure**: AWS resources provisioned with Terraform
2. **Application**: React app containerized with multi-stage Docker build
3. **CI/CD**: Jenkins pipeline for automated build and deployment
4. **Orchestration**: Kubernetes with kind for local development
5. **Logging**: Fluent Bit aggregating logs to CloudWatch

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                      AWS Cloud                          │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │              VPC: 10.0.0.0/16                    │  │
│  │                                                  │  │
│  │  ┌────────────────────────────────────────────┐ │  │
│  │  │  Public Subnet: 10.0.1.0/24               │ │  │
│  │  │                                            │ │  │
│  │  │  ┌──────────────────────────────────────┐ │ │  │
│  │  │  │    EC2 Instance (t2.medium)         │ │ │  │
│  │  │  │  - Docker                           │ │ │  │
│  │  │  │  - kubectl                          │ │ │  │
│  │  │  │  - kind                             │ │ │  │
│  │  │  │                                      │ │ │  │
│  │  │  │  ┌──────────────────────────────┐  │ │ │  │
│  │  │  │  │   Jenkins (Port 8080)       │  │ │ │  │
│  │  │  │  │  - Agent 1                  │  │ │ │  │
│  │  │  │  │  - Agent 2                  │  │ │ │  │
│  │  │  │  └──────────────────────────────┘  │ │ │  │
│  │  │  │                                      │ │ │  │
│  │  │  │  ┌──────────────────────────────┐  │ │ │  │
│  │  │  │  │   Kind Cluster              │  │ │ │  │
│  │  │  │  │  - Control Plane            │  │ │ │  │
│  │  │  │  │  - Worker Node              │  │ │ │  │
│  │  │  │  │  - React App (Port 3000)    │  │ │ │  │
│  │  │  │  │  - Fluent Bit (Logging)     │  │ │ │  │
│  │  │  │  └──────────────────────────────┘  │ │ │  │
│  │  │  └──────────────────────────────────┘ │ │ │  │
│  │  │  Elastic IP: xxx.xxx.xxx.xxx           │ │ │  │
│  │  └────────────────────────────────────────┘ │ │  │
│  │                                              │ │  │
│  │  ┌────────────────────────────────────────┐ │ │  │
│  │  │  Security Group                        │ │ │  │
│  │  │  - SSH (22)                            │ │ │  │
│  │  │  - HTTP (80)                           │ │ │  │
│  │  │  - Jenkins (8080)                      │ │ │  │
│  │  │  - React App (3000)                    │ │ │  │
│  │  └────────────────────────────────────────┘ │ │  │
│  │                                              │ │  │
│  │  Internet Gateway                            │ │  │
│  │         ↓                                     │ │  │
│  │  Route Table (0.0.0.0/0)                     │ │  │
│  └──────────────────────────────────────────────┘ │  │
│                                                   │  │
│  CloudWatch Logs: /aws/eks/react-app-logs        │  │
│                                                   │  │
└─────────────────────────────────────────────────────┘
```

## Directory Structure

```
react-hello-world/
├── terraform/                 # Infrastructure as Code
│   ├── main.tf               # VPC, EC2, IAM, security group
│   ├── variables.tf          # Input variables
│   ├── outputs.tf            # Output values
│   └── terraform.tfvars      # Variable values (CONFIGURE THESE)
│
├── app/                       # React Application
│   ├── Dockerfile            # Multi-stage Docker build
│   ├── nginx.conf            # Nginx configuration
│   └── .dockerignore         # Docker ignore file
│
├── jenkins/                   # CI/CD
│   ├── Dockerfile            # Jenkins image with Docker support
│   ├── docker-compose.yml    # Jenkins + 2 agents setup
│   └── setup-jenkins.sh      # Setup script
│
├── k8s/                       # Kubernetes
│   ├── kind-config.yaml      # kind cluster configuration
│   ├── namespace.yaml        # Kubernetes namespace
│   ├── deployment.yaml       # React app deployment
│   ├── service.yaml          # Service and HPA
│   ├── fluent-bit.yaml       # Fluent Bit for CloudWatch
│   ├── fluent-bit-local.yaml # Fluent Bit for local testing
│   └── setup-kind.sh         # Setup script
│
└── Jenkinsfile               # CI/CD Pipeline definition
```

## Prerequisites

### Local Development
- Docker Desktop or Docker Engine
- kubectl
- kind
- git
- Terraform (for AWS deployment)

### AWS Account
- AWS access keys configured
- Appropriate IAM permissions
- CloudWatch Logs service available

### Docker Hub
- Docker Hub account
- Username and access token

### GitHub
- GitHub repository with React app code
- Repository access token (for Jenkins)

## Quick Start

### 1. Configure Variables

**Update `terraform/terraform.tfvars`:**
```hcl
aws_region       = "us-east-1"              # Your AWS region
ami_id           = "ami-0c55b159cbfafe1f0" # Ubuntu 22.04 AMI for your region
public_key       = "ssh-rsa AAAA..."        # Your public SSH key
allowed_ssh_cidr = "YOUR_IP/32"             # Your IP for SSH access
```

**Update `k8s/deployment.yaml`:**
```yaml
image: docker.io/YOUR_DOCKER_HUB_USERNAME/react-app:latest
```

**Update `Jenkinsfile`:**
```groovy
DOCKER_HUB_USERNAME = 'YOUR_DOCKER_HUB_USERNAME'
GitHub Repository URL: https://github.com/YOUR_USERNAME/react-app.git
AWS_REGION = 'your-region'
AWS_ACCOUNT_ID = 'your-account-id'
```

### 2. Deploy Infrastructure (AWS)

```bash
cd terraform

# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Apply infrastructure
terraform apply

# Get output values
terraform output
```

**Output includes:**
- EC2 Instance Public IP
- SSH command to connect
- Jenkins URL
- React app URL
- CloudWatch log group name

### 3. Connect to EC2 Instance

```bash
ssh -i /path/to/private/key.pem ubuntu@<PUBLIC_IP>

# Verify tools are installed
docker --version
kubectl version --client
kind version
git --version
```

### 4. Set Up Kubernetes Cluster (on EC2)

```bash
# Connect to EC2 instance
ssh -i /path/to/private/key.pem ubuntu@<PUBLIC_IP>

# Clone the project
git clone <YOUR_REPO_URL>
cd react-hello-world

# Create kind cluster
cd k8s
chmod +x setup-kind.sh
./setup-kind.sh

# Verify cluster
kubectl get nodes
```

### 5. Set Up Jenkins (on EC2)

```bash
cd jenkins
chmod +x setup-jenkins.sh

# Build and start Jenkins
./setup-jenkins.sh

# Get initial admin password
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

**Access Jenkins:**
- URL: `http://<EC2_PUBLIC_IP>:8080`
- Username: `admin`
- Password: (from command above)

### 6. Configure Jenkins

#### Step 1: Configure Credentials
- Go to: Manage Jenkins → Credentials → System
- Click "Add Credentials"
- Create SSH key for agents:
  ```bash
  ssh-keygen -t rsa -b 4096 -f jenkins_agent_key -N ''
  ```

#### Step 2: Configure Nodes/Agents
- Go to: Manage Jenkins → Nodes and Clouds
- For each agent (agent-docker-1, agent-docker-2):
  - Click "New Node"
  - Configure SSH connection to agent container
  - Set remote root directory: `/home/jenkins/agent`

#### Step 3: Install Plugins
- Go to: Manage Jenkins → Plugins
- Install: Docker Pipeline, Docker, Pipeline, Git, GitHub

#### Step 4: Create Pipeline Job
- New Job → Pipeline
- Name: `react-app-pipeline`
- Pipeline: Pipeline script from SCM
- SCM: Git
- Repository URL: Your GitHub repository
- Script path: `Jenkinsfile`

### 7. Deploy React App

```bash
# Build and push Docker image to Docker Hub
cd app
docker build -t YOUR_DOCKER_HUB_USERNAME/react-app:v1.0 .
docker push YOUR_DOCKER_HUB_USERNAME/react-app:v1.0

# Deploy to Kubernetes
cd ../k8s
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

### 8. Access React App

**Option 1: NodePort Service (kind)**
```bash
# Get NodePort
kubectl get svc -n react-app

# Access at: http://localhost:30000
```

**Option 2: Port Forward**
```bash
kubectl port-forward svc/react-app-service -n react-app 3000:80
# Access at: http://localhost:3000
```

### 9. Set Up Logging

#### Option A: CloudWatch (AWS)

```bash
# Create AWS IAM role for Fluent Bit
# (See Fluent Bit section below)

# Deploy Fluent Bit to CloudWatch
kubectl apply -f fluent-bit.yaml

# View logs in CloudWatch Console
# Log Group: /aws/eks/react-app-logs
```

#### Option B: Local Testing (kind)

```bash
# Deploy Fluent Bit with local output
kubectl apply -f fluent-bit-local.yaml

# View logs
kubectl logs -f daemonset/fluent-bit -n logging
```

## Component Details

### 1. Terraform Infrastructure

**VPC Configuration:**
- CIDR: 10.0.0.0/16
- Public Subnet: 10.0.1.0/24
- Internet Gateway: Internet connectivity
- Route Table: 0.0.0.0/0 → IGW
- Elastic IP: Static public IP

**EC2 Instance:**
- Type: t2.medium
- OS: Ubuntu 22.04 LTS
- Root Volume: 20 GB (gp3)
- User Data: Installs Docker, kubectl, kind, git

**Security Group:**
- SSH (22): From specified CIDR
- HTTP (80): From anywhere
- Jenkins (8080): From anywhere
- React App (3000): From anywhere

**IAM Role:**
- Permissions: CloudWatch Logs (CreateLogGroup, CreateLogStream, PutLogEvents)
- Attached to: EC2 instance

### 2. Docker Image (React App)

**Multi-stage Build:**
- **Stage 1 (Builder):** node:18-alpine
  - Install dependencies
  - Build React app (npm run build)

- **Stage 2 (Production):** nginx:alpine
  - Copy nginx configuration
  - Copy built files from builder
  - Expose port 80

**Benefits:**
- Smaller image size (~50MB vs 500MB+)
- Production-optimized
- Security best practices

### 3. Jenkins

**Master:**
- Image: jenkins/jenkins:latest with Docker support
- Ports: 8080 (web), 50000 (agent communication)
- Volume: jenkins_home (persistent data)
- Plugins: Pre-installed common plugins

**Agents:**
- Image: jenkins/inbound-agent:latest
- Count: 2 agents (agent-docker-1, agent-docker-2)
- Docker Access: Mounted socket for DinD
- Network: Custom bridge network for internal communication

**Pipeline:**
- Checkout code from GitHub
- Build Docker image
- Push to Docker Hub
- Deploy to Kubernetes

### 4. Kubernetes Cluster (kind)

**Cluster Configuration:**
- Control-plane: 1 node
- Worker nodes: 1 node
- Networking: Flannel CNI
- Port Mappings: 80, 443, 3000, 8080, 30000

**Pods:**
- React App: 2 replicas (rolling update strategy)
- Fluent Bit: DaemonSet (runs on all nodes)

**Services:**
- Service Type: NodePort (port 30000)
- ClusterIP: Internal service discovery
- HPA: Auto-scaling (2-5 replicas based on CPU/memory)

### 5. Fluent Bit Logging

**Architecture:**
- **Input:** Kubernetes container logs
- **Filter:** Kubernetes metadata enrichment
- **Output:** AWS CloudWatch Logs

**Configuration:**
- Log Group: `/aws/eks/react-app-logs`
- Region: `ap-south-1` (configurable)
- Auto-create Log Group: Enabled
- Metadata: Cluster name, environment tags

**DaemonSet:**
- Runs on every node
- Mounts: /var/log, Docker socket, journald logs
- RBAC: Permissions to read pod/node metadata
- Resource Limits: CPU 100m-500m, Memory 128Mi-512Mi

## AWS IAM Setup for Fluent Bit

### Option 1: EC2 Instance Profile (Current Setup)

The Terraform code creates an IAM role attached to the EC2 instance with CloudWatch Logs permissions.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
```

### Option 2: IRSA (IAM Roles for Service Accounts)

For production Kubernetes on AWS EKS:

```bash
# Create IAM policy
aws iam create-policy --policy-name FluentBitCloudWatchLogs \
  --policy-document file://fluent-bit-policy.json

# Create service account with IAM role
eksctl create iamserviceaccount \
  --name fluent-bit \
  --namespace logging \
  --cluster <CLUSTER_NAME> \
  --role-name fluent-bit-role \
  --attach-policy-arn arn:aws:iam::<ACCOUNT_ID>:policy/FluentBitCloudWatchLogs
```

## Monitoring and Debugging

### View Kubernetes Resources

```bash
# Cluster info
kubectl cluster-info

# Nodes
kubectl get nodes -o wide
kubectl describe node <NODE_NAME>

# Pods
kubectl get pods -n react-app
kubectl describe pod <POD_NAME> -n react-app

# Deployments
kubectl get deployment -n react-app
kubectl describe deployment react-app-deployment -n react-app

# Services
kubectl get svc -n react-app
kubectl describe svc react-app-service -n react-app

# HPA status
kubectl get hpa -n react-app
kubectl describe hpa react-app-hpa -n react-app
```

### View Logs

```bash
# Application logs
kubectl logs <POD_NAME> -n react-app
kubectl logs -f deployment/react-app-deployment -n react-app

# Previous logs (if container crashed)
kubectl logs <POD_NAME> -n react-app --previous

# Fluent Bit logs
kubectl logs -f daemonset/fluent-bit -n logging

# Jenkins logs
docker logs -f jenkins
docker logs -f jenkins_agent_1
```

### Test Application

```bash
# Port forward and test
kubectl port-forward svc/react-app-service -n react-app 3000:80
curl http://localhost:3000

# Or use NodePort (kind runs on localhost)
curl http://localhost:30000

# Get pod IP and test directly
POD_IP=$(kubectl get pod -n react-app -o jsonpath='{.items[0].status.podIP}')
curl http://$POD_IP
```

### Troubleshooting

#### Pods not starting
```bash
# Check pod events
kubectl describe pod <POD_NAME> -n react-app

# Check logs
kubectl logs <POD_NAME> -n react-app

# Check events
kubectl get events -n react-app
```

#### Image pull errors
```bash
# Create image pull secret if using private registry
kubectl create secret docker-registry docker-hub-secret \
  --docker-server=docker.io \
  --docker-username=YOUR_USERNAME \
  --docker-password=YOUR_TOKEN \
  -n react-app
```

#### Service not accessible
```bash
# Check service endpoints
kubectl get endpoints -n react-app

# Check DNS resolution
kubectl run -it --image=busybox --restart=Never debug -- \
  nslookup react-app-service.react-app.svc.cluster.local
```

#### Logs not appearing in CloudWatch
```bash
# Check Fluent Bit pod status
kubectl get pods -n logging
kubectl logs <FLUENT_BIT_POD> -n logging

# Check CloudWatch logs
aws logs describe-log-groups --region ap-south-1
aws logs describe-log-streams --log-group-name /aws/eks/react-app-logs
```

## Cleanup

### Delete Kubernetes Resources

```bash
# Delete deployments and services
kubectl delete deployment react-app-deployment -n react-app
kubectl delete svc react-app-service -n react-app
kubectl delete hpa react-app-hpa -n react-app

# Delete namespace
kubectl delete namespace react-app
kubectl delete namespace logging

# Delete kind cluster
kind delete cluster --name react-app-cluster
```

### Stop Jenkins

```bash
cd jenkins
docker-compose down

# Remove volumes
docker volume rm jenkins_jenkins_home
```

### Destroy AWS Infrastructure

```bash
cd terraform
terraform destroy
```

## Next Steps

1. **Customize React App**
   - Update app source code
   - Rebuild Docker image
   - Push to Docker Hub
   - Update Kubernetes deployment

2. **Set up Auto-scaling**
   - HPA is already configured
   - Scale based on CPU/memory usage

3. **Add Monitoring**
   - Install Prometheus and Grafana
   - Configure metrics collection
   - Create dashboards

4. **Add Ingress**
   - Install Ingress controller
   - Configure domain names
   - Enable TLS/HTTPS

5. **Implement GitOps**
   - Use ArgoCD or Flux
   - Automatic deployment on git push
   - Policy as code

6. **Set up Alerts**
   - CloudWatch Alarms for logs
   - Jenkins build notifications
   - Pod replica alerts

## Security Best Practices

1. **Restrict SSH Access:** Update `allowed_ssh_cidr` to your IP
2. **Use IAM Roles:** Don't use AWS Access Keys
3. **Enable Encryption:** All data in transit and at rest
4. **Regular Updates:** Keep Docker, Kubernetes, and packages updated
5. **Network Policies:** Implement Kubernetes NetworkPolicies
6. **Image Scanning:** Scan Docker images for vulnerabilities
7. **Secrets Management:** Use AWS Secrets Manager or HashiCorp Vault
8. **RBAC:** Implement least privilege access

## Cost Optimization

1. **EC2 Instance:** t2.medium (~$0.05/hour)
2. **Reserved Instances:** 40-60% savings with 1-year commitment
3. **Spot Instances:** Up to 90% savings (use for non-critical workloads)
4. **CloudWatch Logs:** ~$0.50/GB ingested (first 5GB free)
5. **Data Transfer:** EU region offers better pricing
6. **NAT Gateway:** Consider NAT instance for savings

## Support and Resources

- [Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [AWS Documentation](https://docs.aws.amazon.com/)
- [Fluent Bit Documentation](https://docs.fluentbit.io/)

## License

This project is provided as-is for educational and demonstration purposes.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

---

**Last Updated:** March 2026

**Version:** 1.0.0
