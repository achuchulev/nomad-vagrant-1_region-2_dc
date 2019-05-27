#!/bin/bash

systemctl stop apt-daily.service
systemctl kill --kill-who=all apt-daily.service
# wait until `apt-get updated` has been killed
while ! (systemctl list-units --all apt-daily.service | fgrep -q dead)
do
  sleep 1;
done

# Make sure apt repository db is up to date
export DEBIAN_FRONTEND=noninteractive

# Install Docker required for Nomad docker driver
which docker &>/dev/null || {
  apt update
  apt install docker.io -y
  usermod -G docker -a vagrant
}

# Check that docker is working
docker run hello-world &>/dev/null && echo docker hello-world works