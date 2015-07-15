opsview_client Cookbook
=======================
This cookbook deploys the OpsView Agent software and provides a LWRP so that chef-client can dynamically
register and update host entries on the OpsView master.


Attributes
----------

#### opsview_client::default
 Key                             | Type    | Description                        | Default        
---------------------------------|---------|------------------------------------|----------------
`['opsview']['server_url']`      | String  | FQDN of your OpsView Master Server | `uat.opsview.com`
`['opsview']['server_protocol']` | String  | http or https                      | `https`
`['opsview']['server_port']`     | String  | Port the OpsView server is on      | `443`
`['opsview']['hosttemplates']`   | List    | List of host templates used to monitor the host with | `[ 'Network - Base' ]`
`['opsview']['reload_opsview']`  | Boolean | Reload OpsView configuration after registering host | `true`
`['opsview']['exclude_fs_type']` | List    | List of filesystem types to exclude when processing node['filesystem'] to construct a list of host attributes | `[ 'usbfs', 'devpts', 'devtmpfs', 'binfmt_misc', 'proc', 'rootfs', 'sysfs', 'tmpfs' ]`
`['opsview']['default_node']`    | Hash    | Hash representation of the JSON object used to register new hosts with the OpsView API   | See attributes/default.rb

#### opsview_client::setup_rhel_agent
 Key                                             | Type    | Description                                        | Default        
-------------------------------------------------|---------|----------------------------------------------------|----------------
`['opsview']['agent']['installation_method']`    | String  | Installation method for the agent - set up a yum repo, or assume it already exists (local) | `repo`
`['opsview']['agent']['packages']`               | Hash    | Packages (and specific versions, if needed) to install | `{ 'libmcrypt' => nil, 'opsview-agent' => nil }`
`['opsview']['agent']['conf_dir']`               | String  | Directory where the opsview-agent config files are | `/usr/local/nagios/etc`
`['opsview']['agent']['log_facility']`           | String  | nrpe.cfg parameter - syslog facility that should be used for logging | `daemon`
`['opsview']['agent']['pid_file']`               | String  | nrpe.cfg parameter - pid file for the opsview-agent process | `/var/tmp/nrpe.pid`
`['opsview']['agent']['server_port']`            | String  | nrpe.cfg parameter - what port the agent will listen on | `5666`
`['opsview']['agent']['server_address']`         | String  | nrpe.cfg parameter - what IP address to bind to    | `0.0.0.0`
`['opsview']['agent']['nrpe_user']`              | String  | nrpe.cfg parameter - user to run as                | `nagios`
`['opsview']['agent']['nrpe_group']`             | String  | nrpe.cfg parameter - group to run as               | `nagios`
`['opsview']['agent']['allowed_hosts']`          | String  | nrpe.cfg parameter - comma-separated list of allowed host IPs | `127.0.0.1`
`['opsview']['agent']['dont_blame_nrpe']`        | String  | nrpe.cfg parameter - Whether to allow command arguments (1 to allow) | `1`
`['opsview']['agent']['debug']`                  | String  | nrpe.cfg parameter - Whether to log debug messages | `0`
`['opsview']['agent']['command_timeout']`        | String  | nrpe.cfg parameter - max number of seconds allowed for plugins to finish | `60`
`['opsview']['agent']['connection_timeout']`     | String  | nrpe.cfg parameter - max number of seconds the agent will wait for connections to get established | `300`
`['opsview']['agent']['allow_weak_random_seed']` | String  | nrpe.cfg parameter - whether to use pseudo random generator if /dev/[u]random unavailable | `1`
`['opsview']['agent']['include_dirs']`           | List    | >nrpe.cfg parameter - List of include directories to scan for cfg files | `/usr/local/nagios/etc/nrpe_local`
`['opsview']['agent']['include_files']`          | List    | nrpe.cfg parameter - List of additional cfg files to include | BLANK
`['opsview']['agent']['default_commands']`       | Boolean | nrpe.cfg parameter - Whether to define the default check commands, such as check_load and check_disk | `true`
`['opsview']['agent']['manage_config']`          | Boolean | Chef will manage the configuration file from the cookbook template. When false, will only create the file if it is missing. | `true`

#### opsview_client::setup_windows_agent
 Key                                             | Type    | Description                                                  | Default        
-------------------------------------------------|---------|--------------------------------------------------------------|----------------
`['opsview']['agent']['x64']['url']`             | String  | Download URL or local source for the 64-bit Install MSI file | [Opsview_Windows_Agent_x64_28-01-15-1600.msi](https://s3.amazonaws.com/opsview-agents/Windows/Opsview_Windows_Agent_x64_28-01-15-1600.msi)
`['opsview']['agent']['Win32']['url']`           | String  | Download URL or local source for the 32-bit Install MSI file | [Opsview_Windows_Agent_Win32_28-01-15-1559.msi](https://s3.amazonaws.com/opsview-agents/Windows/Opsview_Windows_Agent_Win32_28-01-15-1559.msi)
`['opsview']['agent']['windows_conf_dir']`       | String  | Directory where the opsview-agent config files are           | `C:\Program Files\Opsview Agent`
`['opsview']['agent']['manage_ncslient_config']` | Boolean | Chef will manage the configuration file from the cookbook template. When false, will only create the file if it is missing. | `true`

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
  * Rob Coward (rob@coward-family.net)
  * Tenyo Grozev (tenyo.grozev@yale.edu)

Copyright 2015 New Voice Media

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

