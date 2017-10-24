#
# Cookbook:: destroykube
# Recipe:: default
#
# Copyright:: 2017, a_pankratyev, All Rights Reserved.
#


# Kubectl remove
remote_file '/usr/local/bin/kubectl' do
  mode '0755'
  action :delete
  only_if { File.exist?('/usr/local/bin/kubectl') }
end

# Minicube remove
remote_file '/usr/local/bin/minikube' do
  action :delete
  only_if { File.exist?('/usr/local/bin/minikube') }
end

print("#{node[:user_dir]}")
directory "#{node['user_dir']}" do
  recursive true
  action :delete
end

# Helm remove
remote_file '/usr/local/bin/helm' do
  action :delete
  only_if { File.exist?('/usr/local/bin/helm') }
end
