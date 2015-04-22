#
# Cookbook Name:: opsview_client
# Recipe:: setup_rhel_agent
#
# Author: Tenyo Grozev (tenyo.grozev@yale.edu)
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

if node['opsview']['agent']['installation_method'] == 'repo'

  # add the epel repo, needed for the libmcrypt package
  include_recipe "yum-epel::default"

  yum_repository "opsview-core" do
    description "Opsview Core"
    gpgcheck false
    case node['platform']
    when "redhat"
      baseurl "http://downloads.opsview.com/opsview-core/latest/yum/rhel/$releasever/$basearch"
    when "centos"
      baseurl "http://downloads.opsview.com/opsview-core/latest/yum/centos/$releasever/$basearch"
    end
    action :create
  end

end

# Install packages
node['opsview']['agent']['packages'].each do |pkg,ver|
  package pkg do
    action :install
    version ver if ver
  end
end

template "#{node['opsview']['agent']['conf_dir']}/nrpe.cfg" do
  source 'nrpe.cfg.erb'
  mode '0444'
  user node['opsview']['agent']['nrpe_user']
  group node['opsview']['agent']['nrpe_group']
  notifies :restart, 'service[opsview-agent]', :immediately
end

service "opsview-agent" do
  action [ :enable, :start ]
end

