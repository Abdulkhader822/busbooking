# 🎯 Your Next Steps - RouteBuddy Deployment

## ✅ What's Already Done

1. ✅ Azure SQL Server configured
2. ✅ Azure VM launched with Jenkins
3. ✅ Application code ready (Frontend + Backend)
4. ✅ Dockerfiles created
5. ✅ CI/CD pipeline configured

---

## 🚀 What You Need to Do NOW

### STEP 1: Update Configuration Files (5 minutes)

#### A. Update `Jenkinsfile` (Lines 5-8)
```groovy
DOCKERHUB_USERNAME = 'your-dockerhub-username'  // Replace with your Docker Hub username
GITHUB_REPO = 'https://github.com/your-username/BusBookingRouteBuddy.git'  // Your GitHub repo
AZURE_VM_HOST = 'your-vm-ip'  // Your Azure VM IP address
```

#### B. Update `frontend/routebuddy/nginx.conf` (Line 11)
```nginx
proxy_pass http://YOUR_VM_IP:5000;  // Replace with your VM IP
```

#### C. Update `deploy-vm.sh` (Line 6)
```bash
DOCKERHUB_USERNAME="your-dockerhub-username"  // Your Docker Hub username
```

---

### STEP 2: Push Code to GitHub (5 minutes)

```bash
# Open Command Prompt or PowerShell
cd c:\Users\abdul\OneDrive\Desktop\delpoyment\BusBookingRouteBuddy

# Initialize Git
git init
git add .
git commit -m "Initial commit - RouteBuddy CI/CD setup"

# Create GitHub repo first at https://github.com/new
# Then push:
git remote add origin https://github.com/YOUR_USERNAME/BusBookingRouteBuddy.git
git branch -M main
git push -u origin main
```

---

### STEP 3: Setup Azure VM (10 minutes)

SSH into your Azure VM and run:

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add Jenkins to docker group
sudo usermod -aG docker jenkins
sudo usermod -aG docker azureuser

# Restart Jenkins
sudo systemctl restart jenkins

# Setup SSH keys for Jenkins
sudo -u jenkins ssh-keygen -t rsa -b 4096 -N ""
sudo cat /var/lib/jenkins/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# Test SSH
sudo -u jenkins ssh azureuser@localhost
# Type 'yes' and exit

# Verify Docker
docker --version
```

---

### STEP 4: Configure Jenkins (10 minutes)

#### A. Install Plugins
1. Open Jenkins: `http://YOUR_VM_IP:8080`
2. Go to: **Manage Jenkins** → **Plugins** → **Available plugins**
3. Search and install:
   - Docker Pipeline
   - Docker Plugin
   - Git Plugin
   - Credentials Binding Plugin

#### B. Add Docker Hub Credentials
1. **Manage Jenkins** → **Credentials** → **System** → **Global credentials**
2. Click **Add Credentials**
3. Fill in:
   - Kind: `Username with password`
   - Username: `your-dockerhub-username`
   - Password: `your-dockerhub-password`
   - ID: `dockerhub-credentials`
   - Description: `Docker Hub Login`
4. Click **Create**

---

### STEP 5: Create Jenkins Pipeline (5 minutes)

1. Jenkins Dashboard → **New Item**
2. Enter name: `RouteBuddy-CICD`
3. Select: **Pipeline**
4. Click **OK**

5. Configure:
   - **Description**: `CI/CD Pipeline for RouteBuddy`
   - **Pipeline** section:
     - Definition: `Pipeline script from SCM`
     - SCM: `Git`
     - Repository URL: `https://github.com/YOUR_USERNAME/BusBookingRouteBuddy.git`
     - Branch: `*/main`
     - Script Path: `Jenkinsfile`
6. Click **Save**

---

### STEP 6: Open Azure Ports (5 minutes)

In Azure Portal:
1. Go to your VM → **Networking** → **Network settings**
2. Add inbound port rules:
   - Port 80 (Frontend)
   - Port 5000 (Backend API)
   - Port 8080 (Jenkins)
   - Port 22 (SSH)

---

### STEP 7: Run First Deployment (2 minutes)

1. Go to Jenkins → `RouteBuddy-CICD` pipeline
2. Click **Build Now**
3. Watch the console output
4. Wait for ✅ Success message

---

### STEP 8: Verify Deployment (2 minutes)

Open in browser:
- Frontend: `http://YOUR_VM_IP`
- Backend: `http://YOUR_VM_IP:5000`

Or test via command:
```bash
curl http://YOUR_VM_IP
curl http://YOUR_VM_IP:5000
```

---

## 🎉 You're Done!

Your CI/CD pipeline is now active. Every time you push code to GitHub:
1. Jenkins detects the change
2. Builds Docker images
3. Pushes to Docker Hub
4. Deploys to Azure VM
5. Application is live!

---

## 📋 Quick Reference

### Your Application URLs:
- **Frontend**: `http://YOUR_VM_IP`
- **Backend API**: `http://YOUR_VM_IP:5000`
- **Jenkins**: `http://YOUR_VM_IP:8080`

### Useful Commands:
```bash
# Check running containers
ssh azureuser@YOUR_VM_IP 'docker ps'

# View logs
ssh azureuser@YOUR_VM_IP 'docker logs routebuddy-backend'
ssh azureuser@YOUR_VM_IP 'docker logs routebuddy-frontend'

# Restart containers
ssh azureuser@YOUR_VM_IP 'docker restart routebuddy-backend routebuddy-frontend'
```

### Deploy New Changes:
```bash
# Make changes to code
git add .
git commit -m "Your changes"
git push

# Jenkins will automatically deploy!
```

---

## 📚 Documentation Files

I've created these files for you:

1. **`Jenkinsfile`** - Main CI/CD pipeline (use this)
2. **`Jenkinsfile.dockercompose`** - Alternative using docker-compose
3. **`deploy-vm.sh`** - Manual deployment script
4. **`DEPLOYMENT_GUIDE.md`** - Detailed step-by-step guide
5. **`QUICK_START.md`** - Quick reference
6. **`NEXT_STEPS.md`** - This file

---

## 🐛 Common Issues & Solutions

### Issue: Jenkins can't build Docker images
**Solution:**
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Issue: Can't access application
**Solution:**
- Check Azure NSG rules (ports 80, 5000 open)
- Check containers: `docker ps`
- Check logs: `docker logs routebuddy-backend`

### Issue: Build fails at Docker push
**Solution:**
- Verify Docker Hub credentials in Jenkins
- Login manually: `docker login`

---

## 🎓 Architecture Summary

```
┌─────────────┐
│   GitHub    │  (Code Repository)
└──────┬──────┘
       │ git push
       ↓
┌─────────────┐
│   Jenkins   │  (CI/CD Server on Azure VM)
└──────┬──────┘
       │ docker build
       ↓
┌─────────────┐
│ Docker Hub  │  (Image Registry)
└──────┬──────┘
       │ docker pull
       ↓
┌─────────────┐
│  Azure VM   │  (Production Server)
│             │
│  Frontend   │  Port 80
│  Backend    │  Port 5000
└──────┬──────┘
       │
       ↓
┌─────────────┐
│  Azure SQL  │  (Database)
└─────────────┘
```

---

## ✅ Final Checklist

Before you start, make sure you have:

- [ ] Docker Hub account created
- [ ] GitHub account and repository created
- [ ] Azure VM IP address noted
- [ ] Jenkins accessible at `http://VM_IP:8080`
- [ ] Azure SQL connection string ready
- [ ] Updated all configuration files with your values

---

## 🚀 Ready to Deploy?

1. **Start with**: `QUICK_START.md` for fast setup
2. **Need details?**: Read `DEPLOYMENT_GUIDE.md`
3. **Follow**: This `NEXT_STEPS.md` file

**Total Time: ~45 minutes** ⏱️

---

## 💡 Pro Tips

1. **Test locally first**: Run `docker-compose up` locally before deploying
2. **Monitor logs**: Always check logs after deployment
3. **Backup database**: Setup automated Azure SQL backups
4. **Use HTTPS**: Add SSL certificate for production
5. **Environment variables**: Never commit secrets to Git

---

## 📞 Need Help?

If something doesn't work:
1. Check Jenkins console output
2. Check Docker logs: `docker logs routebuddy-backend`
3. Verify all credentials are correct
4. Ensure ports are open in Azure NSG
5. Check Azure SQL firewall rules

---

**Good luck with your deployment! 🎉**

**Start with STEP 1 above and follow through STEP 8!**
