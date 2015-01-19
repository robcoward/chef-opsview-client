#
# Cookbook Name:: opsview_client
# Recipe:: test
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

include_recipe "opsview_client"

opsview_client 'client1.fqdn' do 
  api_user 'userid'
  api_password 'passw0rd'
  api_protocol 'http'
  api_port 80
  ip node['ipaddress']
  hostgroup 'Test_Hostgroup'
  hostalias 'Chef client test'
  hosttemplates node['opsview']['hosttemplates']
  reload_opsview false
end

opsview_client 'client2.fqdn' do 
  api_user 'userid'
  api_password 'passw0rd'
  api_protocol 'http'
  api_port 80
  ip node['ipaddress']
  hostgroup 'Test_Hostgroup'
  hostalias 'Chef client test'
  hosttemplates node['opsview']['hosttemplates']
  reload_opsview true
end