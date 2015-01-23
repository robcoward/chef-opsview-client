
default['opsview_client_test']['host'] = 'uat.opsview.com'
default['opsview_client_test']['protocol'] = 'http'
default['opsview_client_test']['port'] = 80
default['opsview_client_test']['user'] = 'userid'
default['opsview_client_test']['password'] = 'passw0rd'
default['opsview_client_test']['reload_opsview'] = false

default['opsview_client_test']['hostgroup'] = 'Test_Hostgroup'
default['opsview_client_test']['hosttemplates'] = [ "Network - Base" ]
default['opsview_client_test']['hostalias'] = 'Chef client test'