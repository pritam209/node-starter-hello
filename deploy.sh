#!/bin/bash

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2
sudo npm install -g pm2

# Navigate to the application directory
cd /home/ubuntu/node-starter

# Stop the existing application
pm2 stop my-app || true

# Start the new application
pm2 start dist/main.js --name my-app

# Save the PM2 process list and corresponding environments
pm2 save
