# -*- mode: ruby -*-
# vi: set ft=ruby :
$hostsfile_update = <<-'SCRIPT'
awk '
BEGIN { control = 0; node1 = 0; node2 = 0; }
/control/ { control = 1 }
/node1/ { node1 = 1 }
/node2/ { node2 = 1 } 
END {
  if (!control) {
    cmd = "echo \"192.168.56.110 control.example.com\" >> /etc/hosts"
    cmd | getline
  }
  if (!node1) {
    cmd = "echo \"192.168.56.111 node1.example.com\" >> /etc/hosts"
    cmd | getline
  }
  if (!node2) {
    cmd = "echo \"192.168.56.112 node2.example.com\" >> /etc/hosts"
    cmd | getline
  }
}
' /etc/hosts
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config && systemctl restart sshd
SCRIPT

$move_repo_to_vault = <<-'VAULT'
for repo in $(find /etc/yum.repos.d/ -type f -name "CentOS-Linux-*" -print); do
  sed -i 's/mirrorlist/#mirrorlist/g' $repo
  sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' $repo
done
VAULT

$ansible_user = <<-'AUSER'
useradd -s /bin/bash -m -d /opt/ansible ansible
echo "password" | passwd --stdin ansible
echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible
AUSER

Vagrant.configure("2") do |config|

  config.vm.define "node1" do |node1|
    node1.vm.box = "centos/8"
    node1.vm.hostname = "node1.example.com"
    node1.vm.network "private_network", ip: "192.168.56.111"
    node1.vm.provision "init", type: "shell", inline: $hostsfile_update
    node1.vm.provision "repo", type: "shell",  inline: $move_repo_to_vault
    node1.vm.provision "ansible_user", type: "shell", inline: $ansible_user
    node1.vm.provision "vim", type: "shell", inline: "yum install -y vim"
    node1.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--audio", "none"]
    end
    node1.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.cpus = 1
    end
  end

  config.vm.define "node2" do |node2|
    node2.vm.box = "centos/8"
    node2.vm.hostname = "node2.example.com"
    node2.vm.network "private_network", ip: "192.168.56.112"
    node2.vm.provision "init", type: "shell", inline: $hostsfile_update
    node2.vm.provision "repo", type: "shell",  inline: $move_repo_to_vault
    node2.vm.provision "ansible_user", type: "shell", inline: $ansible_user
    node2.vm.provision "vim", type: "shell", inline: "yum install -y vim"
    node2.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--audio", "none"]
    end
    node2.vm.provider "virtualbox" do |v| 
      v.memory = 512
      v.cpus = 1
    end
  end

end

