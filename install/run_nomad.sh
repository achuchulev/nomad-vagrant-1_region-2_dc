#!/usr/bin/env bash

  # adjust interfce if not named eth0
  [ -d /etc/nomad.d/ ] && {
    #IFACE=`route -n | awk '$1 ~ "0.0.0.0" {print $8}'`
    IFACE=`route -n | awk '$1 ~ "192.168.*.*" {print $8}'`
    sed -i "s/eth0/${IFACE}/g" /etc/nomad.d/*.hcl
  }

# Enable & start nomad service
systemctl enable nomad.service
systemctl start nomad.service

# Enable Nomad's CLI command autocomplete support
nomad -autocomplete-install

# Export Nomad CLI environment variables to communicating via HTTPS
echo 'export NOMAD_ADDR=https://localhost:4646' >> /home/vagrant/.profile
echo 'export NOMAD_CACERT=/vagrant/ssl/ca/nomad-ca.pem' >> /home/vagrant/.profile
echo 'export NOMAD_CLIENT_CERT=~/nomad/ssl/cli.pem' >> /home/vagrant/.profile
echo 'export NOMAD_CLIENT_KEY=~/nomad/ssl/cli-key.pem' >> /home/vagrant/.profile

chmod +r /home/vagrant/nomad/ssl/cli-key.pem