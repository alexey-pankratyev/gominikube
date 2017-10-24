#
# Cookbook:: gominikube
# Recipe:: default
#
# Copyright:: 2017, a_pankratyev, All Rights Reserved.

# Kubectl installation
node.default['ver_kubectl']=`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`.strip
remote_file '/usr/local/bin/kubectl' do
  source "http://storage.googleapis.com/kubernetes-release/release/#{node['ver_kubectl']}/bin/linux/amd64/kubectl"
  mode '0755'
  action :create
  not_if 'ls /usr/local/bin/kubectl'
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
