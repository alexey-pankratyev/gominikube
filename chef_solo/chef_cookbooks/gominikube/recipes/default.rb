#
# Cookbook:: gominikube
# Recipe:: default
#
# Copyright:: 2017, a_pankratyev, All Rights Reserved.

# install hypervisor packages
package "libvirt" do
  case node[:platform]
  when "centos", "redhat", "fedora"
    package_name "libvirt-daemon-kvm"
  when 'ubuntu', 'debian'
    package_name "libvirt-bin"
  end
end

package "qemu-kvm" do
  case node[:platform]
  when "centos", "redhat", "fedora", "ubuntu", "debian"
    package_name "qemu-kvm"
  end
  action :install
end

# Add you to libvirt or libvirtd group
case node[:platform]
when "centos", "redhat", "fedora"
  execute 'Add you to group libvirt' do
    command 'sudo usermod -a -G libvirt $(whoami) && newgrp libvirt'
  end
when 'ubuntu', 'debian'
  execute 'Add you to group libvird' do
    command 'sudo usermod -a -G libvirtd $(whoami) && newgrp libvirtd'
  end
end

# Kubectl installation
node.default['ver_kubectl']=`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`.strip
remote_file '/usr/local/bin/kubectl' do
  source "http://storage.googleapis.com/kubernetes-release/release/#{node['ver_kubectl']}/bin/linux/amd64/kubectl"
  mode '0755'
  action :create
  not_if 'ls /usr/local/bin/kubectl'
end

# Kubectl installation
node.default['ver_kubectl']=`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`.strip
remote_file '/usr/local/bin/kubectl' do
  source "http://storage.googleapis.com/kubernetes-release/release/#{node['ver_kubectl']}/bin/linux/amd64/kubectl"
  mode '0755'
  action :create
  not_if 'ls /usr/local/bin/kubectl'
end

# Docker-machine installation
node.default['os_ver']=`uname -s`.strip
node.default['os_arch']=`uname -m`.strip
remote_file '/usr/local/bin/docker-machine-driver-kvm' do
  source "https://github.com/docker/machine/releases/download/v0.13.0/docker-machine-#{node['os_ver']}-#{node['os_arch']}"
  mode '0755'
  action :create
  not_if 'ls /usr/local/bin/docker-machine-driver-kvm'
end

# Minicube installation
remote_file '/usr/local/bin/minikube' do
  source "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
  mode '0755'
  action :create
  not_if 'ls /usr/local/bin/minikube'
end

# Helm installation
remote_file '/tmp/get_helm.sh' do
  source "https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get"
  mode '0700'
  action :create
end

execute 'Helm installation' do
  command '/tmp/get_helm.sh'
  ignore_failure true
  not_if 'ls /usr/local/bin/helm'
end

execute 'Check installation helm' do
  command 'ls /usr/local/bin/helm'
end
