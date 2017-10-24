#
# Cookbook:: gominikube
# Recipe:: create_libvirt
#
# Copyright:: 2017, a_pankratyev, All Rights Reserved.

# Install hypervisor packages
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

# Docker-machine installation
node.default['os_ver']=`uname -s`.strip
node.default['os_arch']=`uname -m`.strip
remote_file '/usr/local/bin/docker-machine-driver-kvm' do
  source "https://github.com/docker/machine/releases/download/v0.8.2/docker-machine-#{node['os_ver']}-#{node['os_arch']}"
  mode '0755'
  action :create
  not_if 'ls /usr/local/bin/docker-machine-driver-kvm'
end

# Start libvirt
service 'libvirtd' do
   action [ :enable, :start ]
end
