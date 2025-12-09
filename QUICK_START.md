# ⚡ RouteBuddy Quick Start Guide

## 🎯 What You Need to Change

### 1. Update Jenkinsfile (Line 5-8)
```groovy
DOCKERHUB_USERNAME = 'your-dockerhub-username'
GITHUB_REPO = 'https://github.com/your-username/BusBookingRouteBuddy.git'
AZURE_VM_HOST = 'your-vm-ip-address'
```

### 2. Update Frontend nginx.conf (Line 11)
```nginx
proxy_pass http://YOUR_VM_IP:5000;
```

### 3. Update deploy-vm.sh (Line 6)
```bash
DOCKERHUB_USERNAME="your-dockerhub-username"
```

---

## 🚀 5-Minute Setup

### On Your Local Machine:
```bash
# 1. Push code to GitHub
cd c:\Users\abdul\OneDrive\Desktop\delpoyment\BusBookingRouteBuddy
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/BusBookingRouteBuddy.git
git push -u origin main
```

### On Azure VM (via SSH):
```bash
# 2. Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

# 3. Setup SSH for Jenkins
sudo -u jenkins ssh-keygen -t rsa -b 4096 -N ""
sudo cat /var/lib/jenkins/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

### In Jenkins Web UI:
```
# 4. Add Docker Hub Credentials
Manage Jenkins → Credentials → Add Credentials
- ID: dockerhub-credentials
- Username: your-dockerhub-username
- Password: your-dockerhub-password

# 5. Create Pipeline
New Item → Pipeline → Name: RouteBuddy-CICD
Pipeline → Definition: Pipeline script from SCM
SCM: Git
Repository URL: https://github.com/YOUR_USERNAME/BusBookingRouteBuddy.git
Script Path: Jenkinsfile

# 6. Build Now!
```

---

## 📋 Pre-Deployment Checklist

```
□ Azure SQL Server configured and accessible
□ Azure VM created with public IP
□ Jenkins installed on Azure VM (port 8080)
□ Docker Hub account created
□ GitHub repository created
□ Azure NSG allows ports: 22, 80, 5000, 8080
□ Updated Jenkinsfile with your values
□ Updated nginx.conf with your VM IP
```

---

## 🔥 One-Command Deployment (Manual)

If you want to deploy manually without Jenkins:

```bash
# On your Azure VM
curl -o deploy.sh https://raw.githubusercontent.com/YOUR_USERNAME/BusBookingRouteBuddy/main/deploy-vm.sh
chmod +x deploy.sh
./deploy.sh
```

---

## 🧪 Test Your Deployment

```bash
# Backend API
curl http://YOUR_VM_IP:5000

# Frontend
curl http://YOUR_VM_IP

# Check containers
ssh azureuser@YOUR_VM_IP 'docker ps'
```

---

## 🎬 Jenkins Pipeline Flow

```
1. Checkout Code from GitHub
   ↓
2. Build Backend Docker Image
   ↓
3. Build Frontend Docker Image
   ↓
4. Push Both Images to Docker Hub
   ↓
5. SSH to Azure VM
   ↓
6. Pull Latest Images
   ↓
7. Stop Old Containers
   ↓
8. Start New Containers
   ↓
9. ✅ Deployment Complete!
```

---

## 🐛 Quick Troubleshooting

### Jenkins can't connect to Docker:
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Can't SSH to VM from Jenkins:
```bash
sudo -u jenkins ssh-keygen -t rsa -b 4096 -N ""
sudo cat /var/lib/jenkins/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
sudo -u jenkins ssh azureuser@localhost  # Test
```

### Container won't start:
```bash
docker logs routebuddy-backend
docker logs routebuddy-frontend
```

### Port already in use:
```bash
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
```

---

## 📞 Access URLs

After successful deployment:

- **Frontend**: `http://YOUR_VM_IP`
- **Backend API**: `http://YOUR_VM_IP:5000`
- **Jenkins**: `http://YOUR_VM_IP:8080`

---

## 🔄 Update Application

Just push to GitHub:
```bash
git add .
git commit -m "Update feature"
git push
```

Jenkins will automatically:
1. Detect the change
2. Build new images
3. Deploy to VM

---

## 💡 Pro Tips

1. **Use Environment Variables**: Don't hardcode secrets in code
2. **Enable GitHub Webhooks**: Auto-trigger builds on push
3. **Monitor Logs**: `docker logs -f routebuddy-backend`
4. **Backup Database**: Regular Azure SQL backups
5. **Use HTTPS**: Setup SSL certificate for production

---

## 📚 Files You Created

- ✅ `Jenkinsfile` - Main CI/CD pipeline
- ✅ `Jenkinsfile.dockercompose` - Alternative using docker-compose
- ✅ `deploy-vm.sh` - Manual deployment script
- ✅ `DEPLOYMENT_GUIDE.md` - Detailed guide
- ✅ `QUICK_START.md` - This file

---

**Ready to Deploy? Follow DEPLOYMENT_GUIDE.md for detailed steps!** 🚀
