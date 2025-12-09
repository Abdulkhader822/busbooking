#!/bin/bash

# RouteBuddy - Jenkins VM Setup Script
# Run this script on your Azure VM to setup Docker and Jenkins

set -e

echo "🚀 Starting RouteBuddy Jenkins VM Setup..."
echo "=========================================="

# Update system
echo "📦 Updating system packages..."
sudo apt-get update -y

# Install Docker
echo "🐳 Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
    echo "✅ Docker installed successfully"
else
    echo "✅ Docker already installed"
fi

# Add users to docker group
echo "👥 Adding users to docker group..."
sudo usermod -aG docker jenkins
sudo usermod -aG docker $USER

# Start and enable Docker
echo "🔧 Configuring Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Install Docker Compose
echo "🐳 Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "✅ Docker Compose installed successfully"
else
    echo "✅ Docker Compose already installed"
fi

# Setup SSH for Jenkins
echo "🔑 Setting up SSH keys for Jenkins..."
if [ ! -f /var/lib/jenkins/.ssh/id_rsa ]; then
    sudo -u jenkins mkdir -p /var/lib/jenkins/.ssh
    sudo -u jenkins ssh-keygen -t rsa -b 4096 -N "" -f /var/lib/jenkins/.ssh/id_rsa
    echo "✅ SSH key generated for Jenkins"
else
    echo "✅ SSH key already exists"
fi

# Add Jenkins public key to authorized_keys
echo "🔐 Configuring SSH access..."
sudo cat /var/lib/jenkins/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
sudo chmod 600 ~/.ssh/authorized_keys

# Test SSH connection
echo "🧪 Testing SSH connection..."
sudo -u jenkins ssh -o StrictHostKeyChecking=no $USER@localhost exit 2>/dev/null && echo "✅ SSH connection successful" || echo "⚠️  SSH test failed, but continuing..."

# Restart Jenkins
echo "🔄 Restarting Jenkins..."
sudo systemctl restart jenkins

# Wait for Jenkins to start
echo "⏳ Waiting for Jenkins to start..."
sleep 10

# Display versions
echo ""
echo "📊 Installed Versions:"
echo "====================="
docker --version
docker-compose --version
echo ""

# Display Jenkins initial password
echo "🔑 Jenkins Initial Admin Password:"
echo "=================================="
if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
else
    echo "Password file not found. Jenkins might already be configured."
fi
echo ""

# Display network information
echo "🌐 Network Information:"
echo "======================"
echo "VM IP Address: $(hostname -I | awk '{print $1}')"
echo "Jenkins URL: http://$(hostname -I | awk '{print $1}'):8080"
echo ""

# Display next steps
echo "✅ Setup Complete!"
echo "=================="
echo ""
echo "📋 Next Steps:"
echo "1. Open Jenkins: http://$(hostname -I | awk '{print $1}'):8080"
echo "2. Install required plugins:"
echo "   - Docker Pipeline"
echo "   - Docker Plugin"
echo "   - Git Plugin"
echo "   - Credentials Binding Plugin"
echo "3. Add Docker Hub credentials (ID: dockerhub-credentials)"
echo "4. Create pipeline job pointing to your GitHub repo"
echo "5. Run your first build!"
echo ""
echo "🔧 Useful Commands:"
echo "docker ps                    # List running containers"
echo "docker logs <container>      # View container logs"
echo "sudo systemctl status jenkins # Check Jenkins status"
echo ""
echo "📚 Documentation:"
echo "See DEPLOYMENT_GUIDE.md for detailed instructions"
echo ""
echo "🎉 Happy Deploying!"
