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

opsview_client node['fqdn'] do 
  api_user     node['opsview_client_test']['user']
  api_password node['opsview_client_test']['password']
  api_host     node['opsview_client_test']['host']
  api_protocol node['opsview_client_test']['protocol'] 
  api_port     node['opsview_client_test']['port']
  ip           node['ipaddress']
  hostgroup    node['opsview_client_test']['hostgroup']
  hostalias    node['opsview_client_test']['hostalias']
  hosttemplates node['opsview_client_test']['hosttemplates']
  reload_opsview node['opsview_client_test']['reload_opsview']
end

