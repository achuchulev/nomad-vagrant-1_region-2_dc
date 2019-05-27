#!/bin/bash

chmod +r /home/vagrant/nomad/ssl/cli-key.pem

# Start nginx service
systemctl start nginx.service