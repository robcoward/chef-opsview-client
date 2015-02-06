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
Authors: Rob Coward

Copyright 2015 New Voice Media

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.