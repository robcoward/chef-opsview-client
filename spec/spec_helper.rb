require 'chefspec'
require 'chefspec/berkshelf'
require 'webmock/rspec'

ChefSpec::Coverage.start!

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  # Specify the path for Chef Solo to find cookbooks (default: [inferred from
  # the location of the calling spec file])
  #config.cookbook_path = '/var/cookbooks'

  # Specify the path for Chef Solo to find roles (default: [ascending search])
  #config.role_path = '/var/roles'

  # Specify the path for Chef Solo to find environments (default: [ascending search])
  #config.environment_path = '/var/environments'

  # Specify the Chef log_level (default: :warn)
  #config.log_level = :debug

  # Specify the path to a local JSON file with Ohai data (default: nil)
  #config.path = 'ohai.json'

  # Specify the operating platform to mock Ohai data from (default: nil)
  #config.platform = 'ubuntu'

  # Specify the operating version to mock Ohai data from (default: nil)
  #config.version = '12.04'

	config.before(:each) do
	    stub_request(:post, "http://uat.opsview.com/rest/login").
	      with(:body => "{\"username\":\"userid\",\"password\":\"passw0rd\"}",
	        :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'43', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
	      to_return(:status => 200, :body => "{\"token\": \"moo\"}", :headers => {'Content-Type'=>'application/json'})

	    # stub_request(:get, "http://uat.opsview.com/rest/config/host?json_filter=%7B%22name%22:%20%7B%22-like%22:%20%22my_fqdn%22%7D%7D").
	    #   with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Opsview-Token'=>'moo', 'X-Opsview-Username'=>'userid'}).
	    #   to_return(:status => 200, :body => "{\"list\": [ ]   }", :headers => {})

	    stub_request(:get, "http://uat.opsview.com/rest/config/host?json_filter=%7B%22name%22:%20%7B%22-like%22:%20%22client1.fqdn%22%7D%7D").
         with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Opsview-Token'=>'moo', 'X-Opsview-Username'=>'userid'}).
         to_return(:status => 200, :body => "{\"list\": [ ]   }", :headers => {})

		stub_request(:get, "http://uat.opsview.com/rest/config/host?json_filter=%7B%22name%22:%20%7B%22-like%22:%20%22client2.fqdn%22%7D%7D").
         with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Opsview-Token'=>'moo', 'X-Opsview-Username'=>'userid'}).
         to_return(:status => 200, :body => "{\"list\": [ ]   }", :headers => {})

	    # stub_request(:get, "http://uat.opsview.com/rest/config/host?json_filter=%7B%22name%22:%20%7B%22-like%22:%20%22chefspec.local%22%7D%7D").
	    #   with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Opsview-Token'=>'moo', 'X-Opsview-Username'=>'userid'}).
	    #   to_return(:status => 200, :body => "{ }", :headers => {})  

	     stub_request(:put, "http://uat.opsview.com/rest/config/host").
         with(:body => "{\"flap_detection_enabled\":\"1\",\"snmpv3_privprotocol\":null,\"hosttemplates\":[{\"name\":\"Network - Base\"}],\"keywords\":[],\"check_period\":{\"name\":\"24x7\"},\"hostattributes\":[{\"name\":\"MAC\",\"value\":\"aa-bb-cc-dd-ee\"},{\"name\":\"CHEFSERVER\",\"value\":\"_default\",\"arg1\":\"https://localhost:443\"}],\"notification_period\":{\"name\":\"24x7\"},\"name\":\"client1.fqdn\",\"rancid_vendor\":null,\"snmp_community\":\"public\",\"hostgroup\":{\"name\":\"Test_Hostgroup\"},\"enable_snmp\":\"0\",\"monitored_by\":{\"name\":\"Master Monitoring Server\"},\"alias\":\"Chef client test\",\"uncommitted\":\"0\",\"parents\":[],\"icon\":{\"name\":\"LOGO - Opsview\"},\"retry_check_interval\":\"1\",\"ip\":\"127.0.0.1\",\"use_mrtg\":\"0\",\"servicechecks\":[],\"use_rancid\":\"0\",\"nmis_node_type\":\"router\",\"snmp_version\":\"2c\",\"snmp_max_msg_size\":\"2c\",\"snmp_extended_throughput_data\":\"default\",\"tidy_ifdescr_level\":\"off\",\"snmpv3_authpassword\":\"\",\"use_nmis\":\"0\",\"rancid_connection_type\":\"ssh\",\"snmpv3_authprotocol\":null,\"rancid_username\":null,\"rancid_password\":\"\",\"check_command\":{\"name\":\"ping\"},\"check_attempts\":\"2\",\"check_interval\":\"0\",\"notification_interval\":\"60\",\"snmp_port\":\"161\",\"snmpv3_username\":\"\",\"snmpv3_privpassword\":\"\",\"other_addresses\":\"\"}",
              :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'1147', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Opsview-Token'=>'moo', 'X-Opsview-Username'=>'userid'}).
         to_return(:status => 200, :body => "{ }", :headers => {})

         stub_request(:put, "http://uat.opsview.com/rest/config/host").
         with(:body => "{\"flap_detection_enabled\":\"1\",\"snmpv3_privprotocol\":null,\"hosttemplates\":[{\"name\":\"Network - Base\"}],\"keywords\":[],\"check_period\":{\"name\":\"24x7\"},\"hostattributes\":[{\"name\":\"MAC\",\"value\":\"aa-bb-cc-dd-ee\"},{\"name\":\"CHEFSERVER\",\"value\":\"_default\",\"arg1\":\"https://localhost:443\"}],\"notification_period\":{\"name\":\"24x7\"},\"name\":\"client2.fqdn\",\"rancid_vendor\":null,\"snmp_community\":\"public\",\"hostgroup\":{\"name\":\"Test_Hostgroup\"},\"enable_snmp\":\"0\",\"monitored_by\":{\"name\":\"Master Monitoring Server\"},\"alias\":\"Chef client test\",\"uncommitted\":\"0\",\"parents\":[],\"icon\":{\"name\":\"LOGO - Opsview\"},\"retry_check_interval\":\"1\",\"ip\":\"127.0.0.1\",\"use_mrtg\":\"0\",\"servicechecks\":[],\"use_rancid\":\"0\",\"nmis_node_type\":\"router\",\"snmp_version\":\"2c\",\"snmp_max_msg_size\":\"2c\",\"snmp_extended_throughput_data\":\"default\",\"tidy_ifdescr_level\":\"off\",\"snmpv3_authpassword\":\"\",\"use_nmis\":\"0\",\"rancid_connection_type\":\"ssh\",\"snmpv3_authprotocol\":null,\"rancid_username\":null,\"rancid_password\":\"\",\"check_command\":{\"name\":\"ping\"},\"check_attempts\":\"2\",\"check_interval\":\"0\",\"notification_interval\":\"60\",\"snmp_port\":\"161\",\"snmpv3_username\":\"\",\"snmpv3_privpassword\":\"\",\"other_addresses\":\"\"}",
              :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'1147', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Opsview-Token'=>'moo', 'X-Opsview-Username'=>'userid'}).
         to_return(:status => 200, :body => "{ }", :headers => {})

         stub_request(:post, "http://uat.opsview.com/rest/reload?asynchronous=1").
         with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'0', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Opsview-Token'=>'moo', 'X-Opsview-Username'=>'userid'}).
         to_return(:status => 200, :body => "{ }", :headers => {})
	end
end