#
# Cookbook Name:: opsview_client
# Recipe:: default
#
# Copyright 2014, Rob Coward
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

# build-essential sets up prereqs for chef_gem
include_recipe 'build-essential::default'
chef_gem 'rest-client' do #~FC009
    compile_time true if Chef::Resource::ChefGem.instance_methods(false).include?(:compile_time) 
end
chef_gem 'hashdiff' do #~FC009
    compile_time true if Chef::Resource::ChefGem.instance_methods(false).include?(:compile_time) 
end

# install the appropriate Opsview agent
case node['platform_family']
when 'windows'
        include_recipe 'opsview_client::setup_windows_agent'
when 'rhel'
        include_recipe 'opsview_client::setup_rhel_agent'
end
