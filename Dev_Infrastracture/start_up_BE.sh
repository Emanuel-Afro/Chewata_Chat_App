#!/bin/bash

# Install Docker
sudo apt update -y
sudo apt install -y docker.io

# Install Docker Compose v2 plugin
sudo apt install -y docker-compose-plugin

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Navigate to your code directory where docker-compose.yml exists
cd /home/ubuntu/chewata_chat_app-backend # <--- Change this to the correct path

# Run your existing Docker Compose file
sudo docker compose up -d backend
