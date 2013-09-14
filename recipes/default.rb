#
# Cookbook Name:: kibana
# Recipe:: default
#
# Copyright 2013, John E. Vincent
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

include_recipe 'apt'
include_recipe 'git'
include_recipe 'user'

user_account node['kibana']['user'] do
  system_user true
  gid 'sudo'
end

group node['kibana']['group'] do
  members node['kibana']['user']
  append true
end

include_recipe "kibana::#{node['kibana']['webserver']}"

directory node['kibana']['installdir'] do
  owner node['kibana']['user']
  mode 0755
end

git "#{node['kibana']['installdir']}/#{node['kibana']['branch']}" do
  repository node['kibana']['repo']
  reference node['kibana']['branch']
  action :sync
  user node['kibana']['user']
end

link "#{node['kibana']['installdir']}/current" do
  to "#{node['kibana']['installdir']}/#{node['kibana']['branch']}/dist"
end

template "#{node['kibana']['installdir']}/current/config.js" do
  source node['kibana']['config_template']
  cookbook node['kibana']['config_cookbook']
  mode 0644
  user node['kibana']['user']
end
