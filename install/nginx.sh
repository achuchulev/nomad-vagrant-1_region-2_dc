#!/bin/bash

# Install nginx
echo "Installing nginx...."

# Check if nginx is installed
# Install nginx if not installed
which nginx &>/dev/null || {
  apt update
  apt install -y nginx
}

mkdir -p /home/vagrant/nomad/ssl

# Configure nginx
echo "Configuring nginx...."

# Stop nginx service
systemctl stop nginx.service

# Remove default conf of nginx
[ -f /etc/nginx/sites-available/default ] && {
 rm -fr /etc/nginx/sites-available/default
}

# Copy our nginx conf
cat <<EOF > /etc/nginx/sites-available/default

upstream nomad_backend { 
    server 192.168.10.11:4646;
    server 192.168.10.12:4646;
    server 192.168.10.13:4646;
 } 

server {

    listen 80 default_server;
    server_name localhost;

    location / {
        proxy_pass https://nomad_backend;
        proxy_ssl_verify on;
        proxy_ssl_trusted_certificate /vagrant/ssl/ca/nomad-ca.pem;
        proxy_ssl_certificate /home/vagrant/nomad/ssl/cli.pem;
        proxy_ssl_certificate_key /home/vagrant/nomad/ssl/cli-key.pem;
        proxy_ssl_name server.global.nomad; 
    }
}
EOF
