#!/usr/bin/env bash

# Check if nginx is installed
# Install nginx if not installed
which cfssl cfssljson &>/dev/null || {
  cd /tmp/
  for bin in cfssl cfssl-certinfo cfssljson
  do
    echo "Installing $bin..."
    curl -sSL https://pkg.cfssl.org/R1.2/${bin}_linux-amd64 > /tmp/${bin}
    install /tmp/${bin} /usr/local/bin/${bin}
  done
}

# Check if CA root certificate exists
# if not create new CA
if [ -d ssl/ca ]; then
  if [[ ! (-f ssl/ca/nomad-ca-key.pem && -f ssl/ca/nomad-ca.pem && -f ssl/ca/nomad-ca.csr) ]]; then
    echo "Generating selfsigned CA SSL Root Certificate for Nomad cluster...."
    cfssl print-defaults csr | cfssl gencert -initca - | cfssljson -bare ssl/ca/nomad-ca
  fi
else
  mkdir -p ssl/ca
  echo "Generating selfsigned CA SSL Root Certificate for Nomad cluster...."
  cfssl print-defaults csr | cfssl gencert -initca - | cfssljson -bare ssl/ca/nomad-ca
fi

