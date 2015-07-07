#
# Cookbook Name:: opsview_client
# Recipe:: setup_windows_agent
#
# Copyright 2015, Rob Coward
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

arch = node['kernel']['machine'] == 'x86_64' ? 'x64' : 'Win32'
windows_package "Opsview NSClient++ Windows Agent (#{arch})" do
	source node['opsview']['agent'][arch]['url']
	options "/quiet /norestart" 
	action :install
end

template ::File.join(node['opsview']['agent']['windows_conf_dir'], 'NSC.ini') do
  source 'NSC.ini.erb'
  notifies :restart, 'service[NSClientpp]'
  action node['opsview']['agent']['manage_ncslient_config'] ? :create : :create_if_missing
end


#finally ensure service is running for opsview 
service 'NSClientpp' do
	action [:enable, :start]
end
