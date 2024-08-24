#!/bin/bash

# Update and install necessary packages
sudo apt update
sudo apt install -y build-essential wget

# Download and install 3proxy
wget https://github.com/z3APA3A/3proxy/archive/refs/tags/0.9.4.tar.gz
tar -xvzf 0.9.4.tar.gz
cd 3proxy-0.9.4
make -f Makefile.Linux
sudo mkdir -p /usr/local/etc/3proxy
sudo cp src/3proxy /usr/local/bin/
sudo cp ./scripts/3proxy.service /etc/systemd/system/

# Create 3proxy configuration file
cat <<EOT | sudo tee /usr/local/etc/3proxy/3proxy.cfg
daemon
maxconn 1024
nserver 8.8.8.8
nserver 8.8.4.4
nscache 65536
timeouts 1 5 30 60 180 1800 15 60
setgid 65535
setuid 65535
stacksize 6000
flush
auth strong
users username:CL:password
allow username
proxy -n -a -p8080 -i0.0.0.0 -e0.0.0.0
flush
EOT

# Replace 'username' and 'password' with your desired username and password
sudo sed -i 's/username/YOUR_USERNAME/' /usr/local/etc/3proxy/3proxy.cfg
sudo sed -i 's/password/YOUR_PASSWORD/' /usr/local/etc/3proxy/3proxy.cfg

# Enable and start 3proxy service
sudo systemctl daemon-reload
sudo systemctl enable 3proxy
sudo systemctl start 3proxy

# Check if 3proxy is running
sudo systemctl status 3proxy

# Provide proxy information
echo "HTTP proxy server has been set up successfully."
echo "Proxy details: http://YOUR_SERVER_IP:8080"
