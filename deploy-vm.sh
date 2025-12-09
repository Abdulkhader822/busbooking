#!/bin/bash

# RouteBuddy Deployment Script for Azure VM
# This script pulls and runs the latest Docker images

set -e

DOCKERHUB_USERNAME="YOUR_DOCKERHUB_USERNAME"  # Change this
BACKEND_IMAGE="${DOCKERHUB_USERNAME}/routebuddy-backend:latest"
FRONTEND_IMAGE="${DOCKERHUB_USERNAME}/routebuddy-frontend:latest"

echo "🚀 Starting RouteBuddy Deployment..."

# Stop and remove existing containers
echo "🛑 Stopping existing containers..."
docker stop routebuddy-backend routebuddy-frontend 2>/dev/null || true
docker rm routebuddy-backend routebuddy-frontend 2>/dev/null || true

# Pull latest images
echo "📥 Pulling latest images from Docker Hub..."
docker pull $BACKEND_IMAGE
docker pull $FRONTEND_IMAGE

# Run Backend
echo "🔧 Starting Backend container..."
docker run -d \
  --name routebuddy-backend \
  -p 5000:80 \
  --restart unless-stopped \
  $BACKEND_IMAGE

# Run Frontend
echo "🎨 Starting Frontend container..."
docker run -d \
  --name routebuddy-frontend \
  -p 80:80 \
  --restart unless-stopped \
  $FRONTEND_IMAGE

# Clean up
echo "🧹 Cleaning up old images..."
docker image prune -f

echo "✅ Deployment Complete!"
echo "Backend API: http://$(hostname -I | awk '{print $1}'):5000"
echo "Frontend: http://$(hostname -I | awk '{print $1}')"
