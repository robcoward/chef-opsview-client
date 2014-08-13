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
