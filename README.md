opsview_client Cookbook
=======================
This cookbook deploys the OpsView Agent software and provides a LWRP so that chef-client can dynamically
register and update host entries on the OpsView master.


Attributes
----------

#### opsview_client::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['opsview']['server_url']</tt></td>
    <td>String</td>
    <td>FQDN of your OpsView Master Server</td>
    <td><tt>uat.opsview.com</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['server_protocol']</tt></td>
    <td>String</td>
    <td>http or https</td>
    <td><tt>https</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['server_port']</tt></td>
    <td>String</td>
    <td>Port the OpsView server is on</td>
    <td><tt>443</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['hosttemplates']</tt></td>
    <td>List</td>
    <td>List of host templates used to monitor the host with</td>
    <td><tt>[ 'Network - Base' ]</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['reload_opsview']</tt></td>
    <td>Boolean</td>
    <td>Reload OpsView configuration after registering host</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['exclude_fs_type']</tt></td>
    <td>List</td>
    <td>List of filesystem types to exclude when processing node['filesystem'] to construct a list of host attributes</td>
    <td><tt>[ 'usbfs', 'devpts', 'devtmpfs', 'binfmt_misc', 'proc', 'rootfs', 'sysfs', 'tmpfs' ]</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['default_node']</tt></td>
    <td>Hash</td>
    <td>Hash representation of the JSON object used to register new hosts with the OpsView API</td>
    <td><tt>See attributes/default.rb</tt></td>
  </tr>
</table>

#### opsview_client::setup_rhel_agent
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['installation_method']</tt></td>
    <td>String</td>
    <td>Installation method for the agent - set up a yum repo, or assume it already exists (local)</td>
    <td><tt>repo</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['packages']</tt></td>
    <td>Hash</td>
    <td>Packages (and specific versions, if needed) to install</td>
    <td><tt>{ 'libmcrypt' => nil, 'opsview-agent' => nil }</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['conf_dir']</tt></td>
    <td>String</td>
    <td>Directory where the opsview-agent config files are</td>
    <td><tt>/usr/local/nagios/etc</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['log_facility']</tt></td>
    <td>String</td>
    <td>nrpe.cfg parameter - syslog facility that should be used for logging</td>
    <td><tt>daemon</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['pid_file']</tt></td>
    <td>String</td>
    <td>nrpe.cfg parameter - pid file for the opsview-agent process</td>
    <td><tt>/var/tmp/nrpe.pid</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['server_port']</tt></td>
    <td>String</td>
    <td>nrpe.cfg parameter - what port the agent will listen on</td>
    <td><tt>5666</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['server_address']</tt></td>
    <td>String</td>
    <td>nrpe.cfg parameter - what IP address to bind to</td>
    <td><tt>0.0.0.0</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['nrpe_user']</tt></td>
    <td>String</td>
    <td>nrpe.cfg parameter - user to run as</td>
    <td><tt>nagios</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['nrpe_group']</tt></td>
    <td>String</td>
    <td>nrpe.cfg parameter - group to run as</td>
    <td><tt>nagios</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['allowed_hosts']</tt></td>
    <td>String</td>
    <td>nrpe.cfg parameter - comma-separated list of allowed host IPs</td>
    <td><tt>127.0.0.1</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['dont_blame_nrpe']</tt></td>
    <td>String</td>
    <td>nrpe.cfg parameter - Whether to allow command arguments (1 to allow)</td>
    <td><tt>1</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['debug']</tt></td>
    <td>String</td>
    <td>nrpe.cfg parameter - Whether to log debug messages</td>
    <td><tt>0</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['command_timeout']</tt></td>
    <td>String</td>
    <td>nrpe.cfg parameter - max number of seconds allowed for plugins to finish</td>
    <td><tt>60</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['connection_timeout']</tt></td>
    <td>String</td>
    <td>nrpe.cfg parameter - max number of seconds the agent will wait for connections to get established</td>
    <td><tt>300</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['allow_weak_random_seed']</tt></td>
    <td>String</td>
    <td>nrpe.cfg parameter - whether to use pseudo random generator if /dev/[u]random unavailable</td>
    <td><tt>1</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['include_dirs']</tt></td>
    <td>List</td>
    <td>nrpe.cfg parameter - List of include directories to scan for cfg files</td>
    <td><tt>/usr/local/nagios/etc/nrpe_local</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['include_files']</tt></td>
    <td>List</td>
    <td>nrpe.cfg parameter - List of additional cfg files to include</td>
    <td><tt>BLANK</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['default_commands']</tt></td>
    <td>Boolean</td>
    <td>nrpe.cfg parameter - Whether to define the default check commands, such as check_load and check_disk</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['manage_config']</tt></td>
    <td>Boolean</td>
    <td>Chef will manage the configuration file from the cookbook template. When false, will only create the file if it is missing.</td>
    <td><tt>true</tt></td>
  </tr>
</table>

#### opsview_client::setup_windows_agent
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['x64']['url']</tt></td>
    <td>String</td>
    <td>Download URL or local source for the 64-bit Install MSI file</td>
    <td><a href="https://s3.amazonaws.com/opsview-agents/Windows/Opsview_Windows_Agent_x64_28-01-15-1600.msi">Opsview_Windows_Agent_x64_28-01-15-1600.msi</a></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['Win32']['url']</tt></td>
    <td>String</td>
    <td>Download URL or local source for the 32-bit Install MSI file</td>
    <td><a href="https://s3.amazonaws.com/opsview-agents/Windows/Opsview_Windows_Agent_Win32_28-01-15-1559.msi">Opsview_Windows_Agent_Win32_28-01-15-1559.msi</a></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['windows_conf_dir']</tt></td>
    <td>String</td>
    <td>Directory where the opsview-agent config files are</td>
    <td><tt>C:\Program Files\Opsview Agent</tt></td>
  </tr>
  <tr>
    <td><tt>['opsview']['agent']['manage_ncslient_config']</tt></td>
    <td>Boolean</td>
    <td>Chef will manage the configuration file from the cookbook template. When false, will only create the file if it is missing.</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### opsview_client::default

Just include `opsview_client` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[opsview_client]"
  ]
}
```

#### LWRP

Include this resource in your recipe to have the host dynamically registered with OpsView.

```ruby
opsview_client node['fqdn'] do
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
```

Test-Kitchen
------------
To converge the cookbook will require access to an opsview server api, and user credentials to authenticate with.

Add the following .kitchen.local.yml file to your cookbook directory with the relevant config.
```
---
suites:
- name: client
  run_list: ["recipe[opsview_client_test::test]"]
  attributes: { 'opsview' : { 'server_url' : '192.168.1.1' },
				'opsview_client_test': { 'host': '192.168.1.1', 
										 'user': 'chef', 
										 'password': 'chef'} }
```

Testing the win2012 platform assumes that you have already imported a vagrant box named win2012, configured for winrm access.

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors:
  * Rob Coward
  * Tenyo Grozev (tenyo.grozev@yale.edu)

Copyright 2015 New Voice Media

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

