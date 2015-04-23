#
# Cookbook Name:: opsview_client
# Attributes:: default
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

# override build-essential attribute
default['build-essential']['compile_time'] = true

default['opsview']['server_url'] = 'uat.opsview.com'
default['opsview']['server_port'] = '443'
default['opsview']['server_protocol'] = 'https'

default['opsview']['hosttemplates'] = [ "Network - Base" ]

default['opsview']['reload_opsview'] = true

default['opsview']['exclude_fs_type'] = [ 'usbfs', 'devpts', 'devtmpfs', 'binfmt_misc', 'proc', 'rootfs', 'sysfs', 'tmpfs' ]
default['opsview']['optional_attributes'] = [ 'MAC', 'CHEFSERVER' ]


default['opsview']['default_node']['flap_detection_enabled'] = "1"
default['opsview']['default_node']['snmpv3_privprotocol'] = nil
default['opsview']['default_node']['hosttemplates'] = nil
default['opsview']['default_node']['keywords'] = nil
default['opsview']['default_node']['check_period'] = { "name" => "24x7" }
default['opsview']['default_node']['hostattributes'] = nil
default['opsview']['default_node']['notification_period'] = { "name" => "24x7" }
default['opsview']['default_node']['name'] = "chef-unknown"
default['opsview']['default_node']['rancid_vendor'] = nil
default['opsview']['default_node']['snmp_community'] = "public"
default['opsview']['default_node']['hostgroup'] = { "name" => "From Chef - Unknown"}
default['opsview']['default_node']['enable_snmp'] = "0"
default['opsview']['default_node']['monitored_by'] = { "name" => "Master Monitoring Server"}
default['opsview']['default_node']['alias'] = "Chef Managed Host"
default['opsview']['default_node']['uncommitted'] = "0"
default['opsview']['default_node']['parents'] = [ ]
default['opsview']['default_node']['icon'] = { "name" => "LOGO - Opsview"}
default['opsview']['default_node']['retry_check_interval'] = "1"
default['opsview']['default_node']['ip'] = "localhost"
default['opsview']['default_node']['use_mrtg'] = "0"
default['opsview']['default_node']['servicechecks'] = [ ]
default['opsview']['default_node']['use_rancid'] = "0"
default['opsview']['default_node']['nmis_node_type'] = "router"
default['opsview']['default_node']['snmp_version'] = "2c"
default['opsview']['default_node']['snmp_max_msg_size'] = "2c"
default['opsview']['default_node']['snmp_extended_throughput_data'] = "default"
default['opsview']['default_node']['tidy_ifdescr_level'] = "off"
default['opsview']['default_node']['snmpv3_authpassword'] = ""
default['opsview']['default_node']['use_nmis'] = "0"
default['opsview']['default_node']['rancid_connection_type'] = "ssh"
default['opsview']['default_node']['snmpv3_authprotocol'] = nil
default['opsview']['default_node']['rancid_username'] = nil
default['opsview']['default_node']['rancid_password'] = ''
default['opsview']['default_node']['check_command'] = { "name" => "ping"}
default['opsview']['default_node']['check_attempts'] = "2"
default['opsview']['default_node']['check_interval'] = "0"
default['opsview']['default_node']['notification_interval'] = "60"
default['opsview']['default_node']['snmp_port'] = "161"
default['opsview']['default_node']['snmpv3_username'] = ""
default['opsview']['default_node']['snmpv3_privpassword'] = ""
default['opsview']['default_node']['other_addresses'] = ""
