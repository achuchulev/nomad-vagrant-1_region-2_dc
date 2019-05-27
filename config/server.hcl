data_dir  = "/opt/nomad"

region = "global"

bind_addr = "0.0.0.0"

advertise {
  rpc = "{{ GetInterfaceIP \"eth0\" }}"
  http = "{{ GetInterfaceIP \"eth0\" }}"
  serf = "{{ GetInterfaceIP \"eth0\" }}"
}

server {
  enabled = true
  bootstrap_expect = 3
  authoritative_region = "global"
  server_join {
    retry_join = ["192.168.10.11", "192.168.10.12", "192.168.10.13"]
    retry_max = 5
    retry_interval = "15s"
  }

  encrypt = "cg8StVXbQJ0gPvMd9o7yrg=="
}

# Require TLS
tls {
  http = true
  rpc  = true

  ca_file   = "/vagrant/ssl/ca/nomad-ca.pem"
  cert_file = "/home/vagrant/nomad/ssl/server.pem"
  key_file  = "/home/vagrant/nomad/ssl/server-key.pem"

  verify_server_hostname = true
  verify_https_client    = true
}
