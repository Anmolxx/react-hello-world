# 🎯 Make These 2 Changes Before Deploying!

## Change 1️⃣: Jenkinsfile - AWS Account ID (Line 23)

### Current Code:
```groovy
    environment {
        // REPLACE_ME: Set these credentials in Jenkins Credentials Store
        // Go to: Manage Jenkins > Credentials > System > Add Credentials
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        DOCKER_HUB_USERNAME = 'anmoldeepkaur1103'  // ✅ Already configured
        DOCKER_IMAGE_NAME = "${DOCKER_HUB_USERNAME}/react-app"
        DOCKER_IMAGE_TAG = "${BUILD_NUMBER}_${GIT_SHORT_COMMIT}"
        
        // Kubernetes Configuration
        KUBE_NAMESPACE = 'react-app'
        KUBE_DEPLOYMENT = 'react-app-deployment'
        
        // AWS Configuration
        AWS_REGION = 'us-east-1'                    // ✅ Already configured
        AWS_ACCOUNT_ID = 'REPLACE_ME_AWS_ACCOUNT_ID'  // ❌ CHANGE THIS!
    }
```

### What to Do:

1. **Get your AWS Account ID:**
   ```bash
   aws sts get-caller-identity --query Account --output text
   ```
   This will output a 12-digit number like: `123456789012`

2. **Replace in Jenkinsfile (Line 23):**

### Before:
```groovy
AWS_ACCOUNT_ID = 'REPLACE_ME_AWS_ACCOUNT_ID'
```

### After:
```groovy
AWS_ACCOUNT_ID = '123456789012'  # Your real account ID here
```

---

## Change 2️⃣: Jenkinsfile - GitHub Repository URL (Line 44)

### Current Code:
```groovy
        stage('Checkout') {
            steps {
                script {
                    echo '=== Checking out code from repository ==='
                    // REPLACE_ME: Update the repository URL
                    checkout([$class: 'GitSCM',
                        branches: [[name: '*/main']],
                        userRemoteConfigs: [[
                            url: 'https://github.com/REPLACE_ME_USERNAME/react-app.git'  // ❌ CHANGE THIS!
                        ]]
                    ])
```

### What to Do:

1. **Get your GitHub Repository URL:**
   - Go to: https://github.com/YOUR_USERNAME/YOUR_REPO (your repository)
   - Click green "Code" button (top right of repo page)
   - Copy the HTTPS URL
   - Format: `https://github.com/USERNAME/REPO_NAME.git`

2. **Replace in Jenkinsfile (Line 44):**

### Before:
```groovy
url: 'https://github.com/REPLACE_ME_USERNAME/react-app.git'
```

### After:
```groovy
url: 'https://github.com/anmoldeepkaur1103/react-app.git'
# Or your actual repository:
url: 'https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPO_NAME.git'
```

---

## ⚠️ Additional: Fix Region Mismatch

### File: k8s/fluent-bit.yaml (Line 214)

Your Terraform uses **us-east-1**, but Fluent Bit is set to **ap-south-1**.

### Current Code:
```yaml
        # Environment variables
        env:
        - name: AWS_REGION
          value: "ap-south-1"  # ⚠️ MISMATCH - Your terraform uses us-east-1!
        - name: AWS_ROLE_ARN
          value: ""
```

### Fix:

### Before:
```yaml
value: "ap-south-1"
```

### After:
```yaml
value: "us-east-1"  # Match your terraform region
```

---

## ✅ After Making These Changes

You'll have:

✅ AWS Account ID configured (for CloudWatch integration)
✅ GitHub repository configured (for Jenkins to pull code)
✅ Regional configuration aligned (Fluent Bit matches Terraform)

Then you can:
```bash
# Deploy to AWS:
cd terraform
terraform init
terraform apply

# Or start locally:
./setup-devops.sh
```

---

## 🔍 Summary of All Changes

| Change | File | Line | From | To |
|--------|------|------|------|-----|
| 1 | Jenkinsfile | 23 | `REPLACE_ME_AWS_ACCOUNT_ID` | Your 12-digit Account ID |
| 2 | Jenkinsfile | 44 | `REPLACE_ME_USERNAME/react-app.git` | Your GitHub HTTPS URL |
| 3 | fluent-bit.yaml | 214 | `ap-south-1` | `us-east-1` |

---

## 📋 Verification Checklist

After making changes, verify:

```bash
# 1. Check Jenkinsfile is valid
grep "AWS_ACCOUNT_ID" Jenkinsfile
# Should show: AWS_ACCOUNT_ID = '123456789012'  (your ID)

# 2. Check GitHub URL is valid
grep "github.com" Jenkinsfile
# Should show: url: 'https://github.com/YOUR_USERNAME/YOUR_REPO.git'

# 3. Check Fluent Bit region
grep "ap-south-1\|us-east-1" k8s/fluent-bit.yaml
# Should show only: value: "us-east-1"
```

---

## ⏭️ Ready to Deploy?

Once you've made these 3 changes:

**For Local Development:**
```bash
chmod +x setup-devops.sh
./setup-devops.sh
```

**For AWS Deployment:**
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

**Jenkins Setup:**
```bash
cd jenkins
chmod +x setup-jenkins.sh
./setup-jenkins.sh
```

---

**Time to make changes:** ~5 minutes
**Difficulty:** 🟢 Easy
**Impact:** 🔴 Critical

