#!/usr/bin/env bash

NOMAD_VERSION=0.9.1

which nomad &>/dev/null || {

  echo "Installing Nomad..."

  cd /tmp/
  curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o nomad.zip
  unzip nomad.zip
  install nomad /usr/bin/nomad
  mkdir -p /etc/nomad.d
  chmod a+w /etc/nomad.d

  mkdir -p /opt/nomad

  mkdir -p /home/vagrant/nomad/ssl
}