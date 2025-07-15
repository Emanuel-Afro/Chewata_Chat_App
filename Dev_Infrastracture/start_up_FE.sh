#!/bin/bash
# Update & install Docker
sudo apt update -y
sudo apt install -y docker.io

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Pull your Docker image from Docker Hub
docker pull emanuelafro/chewata_chat_app-frontend:latest

# Run the container on port 3000
docker run -d -p 3000:3000 your-dockerhub-username/your-frontend-image:latest
