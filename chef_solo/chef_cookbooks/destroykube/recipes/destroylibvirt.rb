#
# Cookbook:: destroykube
# Recipe:: destroy_libvirt
#
# Copyright:: 2017, a_pankratyev, All Rights Reserved.

# Remove hypervisor packages
package "libvirt" do
  case node[:platform]
  when "centos", "redhat", "fedora"
    package_name "libvirt-daemon-kvm"
    package_name "libvirt"
  when 'ubuntu', 'debian'
    package_name "libvirt"
    package_name "libvirt-bin"
  end
  action :remove
end

package "qemu-kvm" do
  case node[:platform]
  when "centos", "redhat", "fedora", "ubuntu", "debian"
    package_name "qemu-kvm"
  end
  action :remove
end

# Remove you to libvirt or libvirtd group
case node[:platform]
  when "centos", "redhat", "fedora"
  execute 'Del you to group libvirt' do
    command 'sudo gpasswd -d $(whoami) libvirt'
    only_if 'groups $(whoami)| grep libvirt'
  end
when 'ubuntu', 'debian'
  execute 'Del you to group libvird' do
    command 'sudo gpasswd -d $(whoami) libvirtd'
    only_if 'groups $(whoami)| grep libvirtd'
  end
end

# Docker-machine remove
remote_file '/usr/local/bin/docker-machine-driver-kvm' do
  action :delete
  only_if { File.exist?('/usr/local/bin/docker-machine-driver-kvm') }
end

# Kill remaining process qemu
execute 'Kill process qemu' do
  command 'kill $(pgrep qemu)'
  only_if 'pgrep qemu'
end
