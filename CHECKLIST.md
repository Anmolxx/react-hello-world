# ⚡ CONFIGURATION CHECKLIST - Print This!

```
╔════════════════════════════════════════════════════════════════════╗
║         🎯 CRITICAL CONFIGURATION CHECKLIST 🎯                     ║
║                                                                    ║
║  Your Setup: 90% COMPLETE - Just 2 More Changes Needed!          ║
╚════════════════════════════════════════════════════════════════════╝

TIER 1: CRITICAL (MUST DO BEFORE DEPLOYING)
═══════════════════════════════════════════════════════════════════════

[ ] 1. UPDATE JENKINSFILE - AWS ACCOUNT ID (Line 23)
    
    Location: Jenkinsfile
    Search for: AWS_ACCOUNT_ID = 'REPLACE_ME_AWS_ACCOUNT_ID'
    
    BEFORE:
    ──────────────────────────────────────────────────────────
    AWS_ACCOUNT_ID = 'REPLACE_ME_AWS_ACCOUNT_ID'
    ──────────────────────────────────────────────────────────
    
    AFTER:
    ──────────────────────────────────────────────────────────
    AWS_ACCOUNT_ID = '123456789012'  # Your 12-digit AWS Account ID
    ──────────────────────────────────────────────────────────
    
    Get your Account ID:
    $ aws sts get-caller-identity --query Account --output text
    

[ ] 2. UPDATE JENKINSFILE - GITHUB REPOSITORY URL (Line 44)
    
    Location: Jenkinsfile
    Search for: 'https://github.com/REPLACE_ME_USERNAME/react-app.git'
    
    BEFORE:
    ──────────────────────────────────────────────────────────
    url: 'https://github.com/REPLACE_ME_USERNAME/react-app.git'
    ──────────────────────────────────────────────────────────
    
    AFTER:
    ──────────────────────────────────────────────────────────
    url: 'https://github.com/anmoldeepkaur1103/YOUR_REPO.git'
    ──────────────────────────────────────────────────────────
    
    Get your URL:
    1. Go to your GitHub repo
    2. Click green "Code" button
    3. Copy HTTPS URL
    

═══════════════════════════════════════════════════════════════════════

TIER 2: IMPORTANT (FIX TO ALIGN CONFIGURATION)
═══════════════════════════════════════════════════════════════════════

[ ] 3. UPDATE FLUENT BIT - AWS REGION (Line 214)
    
    Location: k8s/fluent-bit.yaml
    Search for: value: "ap-south-1"
    
    BEFORE:
    ──────────────────────────────────────────────────────────
    - name: AWS_REGION
      value: "ap-south-1"    # WRONG - Mismatch with terraform
    ──────────────────────────────────────────────────────────
    
    AFTER:
    ──────────────────────────────────────────────────────────
    - name: AWS_REGION
      value: "us-east-1"     # Match your terraform region
    ──────────────────────────────────────────────────────────
    

═══════════════════════════════════════════════════════════════════════

TIER 3: SETUP TIME (AFTER JENKINS STARTS)
═══════════════════════════════════════════════════════════════════════

[ ] 4. CONFIGURE JENKINS AGENTS (After running docker-compose up -d)
    
    Steps:
    1. Get Jenkins initial password:
       $ docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
    
    2. Access Jenkins at: http://localhost:8080
    
    3. Create agents in Jenkins UI:
       - Manage Jenkins → New Node
       - Name: agent-docker-1
       - Repeat for: agent-docker-2
    
    4. Get the JENKINS_SECRET from agent configuration
    
    5. Update docker-compose.yml:
       - Line 38: Update agent-docker-1 secret
       - Line 56: Update agent-docker-2 secret
    

═══════════════════════════════════════════════════════════════════════

VERIFICATION
═══════════════════════════════════════════════════════════════════════

After making changes, verify with these commands:

✓ Check AWS Account ID:
  grep "AWS_ACCOUNT_ID = " Jenkinsfile | head -1

✓ Check GitHub URL:
  grep "github.com" Jenkinsfile | grep -v "//"

✓ Check Fluent Bit region:
  grep "ap-south-1\|us-east-1" k8s/fluent-bit.yaml | grep AWS_REGION -A 1

✓ Validate Jenkinsfile syntax (if Jenkins CLI available):
  java -jar jenkins-cli.jar declarative-linter < Jenkinsfile

═══════════════════════════════════════════════════════════════════════

CONFIGURATION STATUS
═══════════════════════════════════════════════════════════════════════

✅ COMPLETED (No Action Needed):
   • terraform/terraform.tfvars (All AWS config done)
   • k8s/deployment.yaml (Docker Hub username set)
   • app/Dockerfile (Ready to build)
   • k8s/kind-config.yaml (Kubernetes defaults OK)

❌ NEEDS UPDATE (Action Required):
   • Jenkinsfile (Lines 23, 44) - AWS Account ID & GitHub URL

⚠️  NEEDS ALIGNMENT (Important):
   • k8s/fluent-bit.yaml (Line 214) - Region mismatch

═══════════════════════════════════════════════════════════════════════

QUICK COMMANDS FOR CHANGES
═══════════════════════════════════════════════════════════════════════

# Get AWS Account ID quickly:
aws sts get-caller-identity --query Account --output text

# Edit Jenkinsfile in VS Code:
code Jenkinsfile

# Edit Fluent Bit config in VS Code:
code k8s/fluent-bit.yaml

# Search and replace (sed - Linux/Mac):
sed -i 's/ap-south-1/us-east-1/g' k8s/fluent-bit.yaml

═══════════════════════════════════════════════════════════════════════

DEPLOYMENT READINESS
═══════════════════════════════════════════════════════════════════════

Current Status: 90% READY 🎉

After completing these changes:
→ 100% READY for local deployment ✅
→ 100% READY for AWS deployment ✅
→ 100% READY for Jenkins setup ✅

═══════════════════════════════════════════════════════════════════════

TIME ESTIMATE
═══════════════════════════════════════════════════════════════════════

⏱️  Getting AWS Account ID:        2 minutes
⏱️  Updating Jenkinsfile AWS ID:   1 minute
⏱️  Getting GitHub URL:             2 minutes
⏱️  Updating Jenkinsfile GitHub:   1 minute
⏱️  Updating Fluent Bit region:    1 minute
   ──────────────────────────────
   TOTAL TIME:                      7 minutes

═══════════════════════════════════════════════════════════════════════

RESOURCES
═══════════════════════════════════════════════════════════════════════

Documentation:
  • README-DEVOPS.md        - Complete guide
  • CONFIGURATION.md        - Configuration details
  • QUICK-REFERENCE.md      - Common commands
  • CHANGES-NEEDED.md       - Detailed change instructions

Support:
  • Check CONFIG-STATUS.md for complete checklist
  • Check individual file comments for help
  • All files have REPLACE_ME markers for clarity

═══════════════════════════════════════════════════════════════════════

NEXT STEPS AFTER MAKING CHANGES
═══════════════════════════════════════════════════════════════════════

Option A: LOCAL DEVELOPMENT (Recommended for testing)
─────────────────────────────────────────────────────
$ chmod +x setup-devops.sh
$ ./setup-devops.sh
  • Select: No for AWS
  • Select: Yes for Kubernetes
  • Select: Yes for Jenkins
$ Access: http://localhost:8080 and http://localhost:30000

Option B: AWS DEPLOYMENT (Production-like)
──────────────────────────────────────────
$ cd terraform
$ terraform init
$ terraform plan
$ terraform apply
$ Access: http://<PUBLIC_IP>:8080 and http://<PUBLIC_IP>:3000

Option C: KUBERNETES ONLY (For testing)
────────────────────────────────────────
$ cd k8s
$ ./setup-kind.sh
$ kubectl apply -f namespace.yaml deployment.yaml service.yaml

═══════════════════════════════════════════════════════════════════════

IMPORTANT NOTES
═══════════════════════════════════════════════════════════════════════

1. AWS Account ID: Required for CloudWatch integration
   - Don't share this with anyone
   - It's a 12-digit number

2. GitHub URL: Must point to your actual repository
   - Jenkins will clone from this URL
   - Must have branch 'main' (or update in Jenkinsfile)

3. Fluent Bit Region: Must match Terraform region
   - Currently: us-east-1 in terraform
   - Must be: us-east-1 in fluent-bit.yaml
   - Otherwise logs won't work

4. Jenkins Agents: Only configure after Jenkins starts
   - Agents are Docker containers
   - They connect to Jenkins master
   - Secrets are generated by Jenkins

═══════════════════════════════════════════════════════════════════════

PRINT & CHECK OFF AS YOU GO ✓

```

---

## Need Help?

Check these files in order:
1. **CHANGES-NEEDED.md** - Detailed instructions with code samples
2. **CONFIG-STATUS.md** - Complete configuration matrix
3. **README-DEVOPS.md** - Full documentation
4. **QUICK-REFERENCE.md** - Common commands

---

**Last Updated:** March 25, 2026
**Configuration Progress:** 90% ✅
