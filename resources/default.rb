#
# Cookbook Name:: opsview_client
# Resources:: default
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

actions :add_or_update, :add, :update
default_action  :add_or_update

attribute :device_title, :kind_of => String, :name_attribute => true
attribute :api_host, :kind_of => String, :default => node['opsview']['server_url'] 
attribute :api_port, :kind_of => Integer, :default => node['opsview']['server_port']
attribute :api_user, :kind_of => String, :required => true
attribute :api_password, :kind_of => String, :required => true
attribute :api_protocol, :kind_of => String, :equal_to => ["http", "https"], :default => node['opsview']['server_protocol']
#attribute :wait_for, :kind_of => Integer, :default => 0
attribute :ip, :kind_of => String, :regex => /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/
attribute :monitored_by, :kind_of => String, :default => "Master Monitoring Server"
attribute :hostgroup, :kind_of => String, :required => true
attribute :hostalias, :kind_of => String, :default => ""
attribute :hosttemplates, :kind_of => [Array, Hash], :default => [ 'Network - Base' ]
attribute :keywords, :kind_of => [Array, Hash], :default => [ ]
attribute :reload_opsview, :kind_of => [TrueClass, FalseClass], :default => node['opsview']['reload_opsview']
attribute :json_data, :kind_of => Hash
attribute :api_token, :kind_of => String