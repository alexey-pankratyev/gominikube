#
# Cookbook Name:: virtualbox
# Recipe:: destroyvbox
#
# Copyright 2017, Alexey Pankratyev
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform_family']
when 'mac_os_x'
  macports_package 'VirtualBox' do
    action :purge
  end

when 'windows'

  win_pkg_version = node['virtualbox']['version']
  Chef::Log.debug("Removing: #{win_pkg_version.inspect}")

  windows_package "Oracle VM VirtualBox #{win_pkg_version}" do
    action :remove
  end

when 'debian'

  apt_repository 'oracle-virtualbox' do
    action :remove
  end

  package "virtualbox-#{node['virtualbox']['version']}" do
    action :remove
  end

  package 'dkms' do
    action :remove
  end

when 'rhel', 'fedora'

  yum_repository 'oracle-virtualbox' do
    action :remove
  end

  yum_repository "VirtualBox-#{node['virtualbox']['version']}" do
    action :remove
  end

end
