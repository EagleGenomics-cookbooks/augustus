#
# Cookbook Name:: augustus
# Recipe:: default
#
# Copyright 2016 Eagle Genomics Ltd
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

include_recipe 'build-essential'
include_recipe 'apt'

package ['tar', 'zlib1g-dev', 'libboost1.55-all-dev'] do
  action :install
end

# See: http://bioinf.uni-greifswald.de/augustus/binaries/README.TXT
apt_repository 'us.archive.ubuntu.com' do
  uri 'http://us.archive.ubuntu.com/ubuntu'
  distribution 'vivid'
  components %w(main universe)
end
# packages that need the alder apt-repository
package ['bamtools', 'libbamtools-dev'] do
  action :install
end
# remove the entry to avoid corrupting apt
apt_repository 'us.archive.ubuntu.com' do
  action :remove
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node['augustus']['filename']}" do
  source node['augustus']['url']
end

execute "Untar #{node['augustus']['filename']}" do
  command "tar -xzvf #{node['augustus']['filename']}"
  cwd Chef::Config[:file_cache_path]
  not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/#{node['augustus']['dirname']}") }
end

bash 'Install augustus' do
  cwd "#{Chef::Config[:file_cache_path]}/#{node['augustus']['dirname']}"
  code <<-EOH
    make
    make install
  EOH
  not_if { ::File.exist?("#{node['augustus']['install_path']}/bin/augustus") }
end

magic_shell_environment 'AUGUSTUS_CONFIG_PATH' do
  value node['augustus']['config']
end

directory node['augustus']['config'] do
  mode 0777
  recursive true
end
