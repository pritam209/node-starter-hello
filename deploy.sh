#!/bin/bash

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed. Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "Node.js is already installed. Skipping installation."
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "npm is not installed. Installing npm..."
    sudo apt-get install -y npm
else
    echo "npm is already installed. Skipping installation."
fi

# Check if PM2 is installed
if ! command -v pm2 &> /dev/null; then
    echo "PM2 is not installed. Installing PM2..."
    sudo npm install -g pm2
else
    echo "PM2 is already installed. Skipping installation."
fi

# Navigate to the application directory
cd /home/ubuntu/

# Stop the existing application
pm2 stop my-app || true

# Start the new application
pm2 start dist/main.js --name my-app

# Save the PM2 process list and corresponding environments
pm2 save
