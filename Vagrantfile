Vagrant.configure("2") do |config|

  config.trigger.before [:up] do |trigger|
    trigger.info = "Running install/gen_self_ca.sh locally..."
    trigger.run = {path: "install/gen_self_ca.sh"}
  end

  # Set memory & CPU for Virtualbox
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "512"
    vb.cpus = "1"
  end

  config.vm.define vm_name="frontend" do |frontend|
    frontend.vm.box = "achuchulev/xenial64"
    frontend.vm.hostname = "frontend"
    frontend.vm.network "private_network", ip: "192.168.10.250"
    frontend.vm.synced_folder ".", "/vagrant", disabled: false
    frontend.vm.provision "shell", path: "install/tools.sh", privileged: "true"
    frontend.vm.provision "shell", path: "install/cfssl.sh", privileged: "true"
    frontend.vm.provision "shell", path: "install/nginx.sh", privileged: "true"
    frontend.vm.provision "shell", inline: "echo '{}' | cfssl gencert -ca='/vagrant/ssl/ca/nomad-ca.pem' -ca-key='/vagrant/ssl/ca/nomad-ca-key.pem' -profile=client - | cfssljson -bare 'nomad/ssl/cli'"
    frontend.vm.provision "shell", path: "install/run_nginx.sh", privileged: "true"
  end

  (1..2).each do |dc|

    (1..3).each do |i|
      config.vm.define vm_name="server#{dc}#{i}" do |server|
        server.vm.box = "achuchulev/xenial64"
        server.vm.hostname = "server#{dc}#{i}"
        server.vm.network "private_network", ip: "192.168.10.#{dc}#{i}"
        server.vm.synced_folder ".", "/vagrant", disabled: false
        server.vm.provision "shell", path: "install/tools.sh", privileged: "true"
        server.vm.provision "shell", path: "install/cfssl.sh", privileged: "true"
        server.vm.provision "shell", path: "install/nomad.sh", privileged: "true"
        server.vm.provision "shell", inline: "cp /vagrant/config/nomad.service /etc/systemd/system", privileged: "true"
        server.vm.provision "shell", inline: "cp /vagrant/config/server.hcl /etc/nomad.d", privileged: "true"
        server.vm.provision "shell", inline: "echo 'datacenter = \"dc#{dc}\"' >> /etc/nomad.d/server.hcl", privileged: "true"
        server.vm.provision "shell", inline: "echo '{}' | cfssl gencert -ca='/vagrant/ssl/ca/nomad-ca.pem' -ca-key='/vagrant/ssl/ca/nomad-ca-key.pem' -config='/vagrant/config/cfssl.json' -hostname='server.global.nomad,localhost,127.0.0.1' - | cfssljson -bare 'nomad/ssl/server'"
        server.vm.provision "shell", inline: "echo '{}' | cfssl gencert -ca='/vagrant/ssl/ca/nomad-ca.pem' -ca-key='/vagrant/ssl/ca/nomad-ca-key.pem' -profile=client - | cfssljson -bare 'nomad/ssl/cli'"
        server.vm.provision "shell", path: "install/run_nomad.sh", privileged: "true"
      end
    end

    (1..1).each do |i|
      config.vm.define vm_name="client#{dc}#{i}" do |client|
        client.vm.box = "achuchulev/xenial64"
        client.vm.hostname = "client#{dc}#{i}"
        client.vm.network "private_network", ip: "192.168.10.1#{dc}#{i}"
        client.vm.synced_folder ".", "/vagrant", disabled: false
        client.vm.provision "shell", path: "install/tools.sh", privileged: "true"
        client.vm.provision "shell", path: "install/driver.sh", privileged: "true"
        client.vm.provision "shell", path: "install/cfssl.sh", privileged: "true"
        client.vm.provision "shell", path: "install/nomad.sh", privileged: "true"
        client.vm.provision "shell", inline: "cp /vagrant/config/nomad.service /etc/systemd/system", privileged: "true"
        client.vm.provision "shell", inline: "cp /vagrant/config/client.hcl /etc/nomad.d", privileged: "true"
        client.vm.provision "shell", inline: "echo 'datacenter = \"dc#{dc}\"' >> /etc/nomad.d/client.hcl", privileged: "true"
        client.vm.provision "shell", inline: "echo '{}' | cfssl gencert -ca='/vagrant/ssl/ca/nomad-ca.pem' -ca-key='/vagrant/ssl/ca/nomad-ca-key.pem' -config='/vagrant/config/cfssl.json' -hostname='client.global.nomad,localhost,127.0.0.1' - | cfssljson -bare 'nomad/ssl/client'"
        client.vm.provision "shell", inline: "echo '{}' | cfssl gencert -ca='/vagrant/ssl/ca/nomad-ca.pem' -ca-key='/vagrant/ssl/ca/nomad-ca-key.pem' -profile=client - | cfssljson -bare 'nomad/ssl/cli'"
        client.vm.provision "shell", path: "install/run_nomad.sh", privileged: "true"
      end
    end
  end  

end