require 'spec_helper'


describe 'opsview_client_test::test' do
  
  context "for a new host" do
    before(:context) do
      WebMock.reset!
      $api_login = stub_request(:post, "http://uat.opsview.com/rest/login").
          with(:body => "{\"username\":\"userid\",\"password\":\"passw0rd\"}",
            :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'43', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => "{\"token\": \"moo\"}", :headers => {'Content-Type'=>'application/json'})

      $api_search = stub_request(:get, "http://uat.opsview.com/rest/config/host?json_filter=%7B%22name%22:%20%7B%22-like%22:%20%22chefspec.local%22%7D%7D").
         with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Opsview-Token'=>'moo', 'X-Opsview-Username'=>'userid'}).
         to_return(:status => 200, :body => "{\"list\": [ ] }", :headers => {})

      $api_update = stub_request(:put, "http://uat.opsview.com/rest/config/host").
          with(:body => "{\"flap_detection_enabled\":\"1\",\"snmpv3_privprotocol\":null,\"hosttemplates\":[{\"name\":\"Network - Base\"}],\"keywords\":[],\"check_period\":{\"name\":\"24x7\"},\"hostattributes\":[{\"name\":\"MAC\",\"value\":\"aa-bb-cc-dd-ee-ff\"},{\"name\":\"CHEFSERVER\",\"value\":\"_default\",\"arg1\":\"https://localhost:443\"}],\"notification_period\":{\"name\":\"24x7\"},\"name\":\"chefspec.local\",\"rancid_vendor\":null,\"snmp_community\":\"public\",\"hostgroup\":{\"name\":\"Test_Hostgroup\"},\"enable_snmp\":\"0\",\"monitored_by\":{\"name\":\"Master Monitoring Server\"},\"alias\":\"Chef client test\",\"uncommitted\":\"0\",\"parents\":[],\"icon\":{\"name\":\"LOGO - Opsview\"},\"retry_check_interval\":\"1\",\"ip\":\"127.0.0.1\",\"use_mrtg\":\"0\",\"servicechecks\":[],\"use_rancid\":\"0\",\"nmis_node_type\":\"router\",\"snmp_version\":\"2c\",\"snmp_max_msg_size\":\"2c\",\"snmp_extended_throughput_data\":\"default\",\"tidy_ifdescr_level\":\"off\",\"snmpv3_authpassword\":\"\",\"use_nmis\":\"0\",\"rancid_connection_type\":\"ssh\",\"snmpv3_authprotocol\":null,\"rancid_username\":null,\"rancid_password\":\"\",\"check_command\":{\"name\":\"ping\"},\"check_attempts\":\"2\",\"check_interval\":\"0\",\"notification_interval\":\"60\",\"snmp_port\":\"161\",\"snmpv3_username\":\"\",\"snmpv3_privpassword\":\"\",\"other_addresses\":\"\"}",
               :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'1152', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Opsview-Token'=>'moo', 'X-Opsview-Username'=>'userid'}).
          to_return(:status => 200, :body => "{ }", :headers => {})
    end

    let(:chef_run) do
      CHEFSPEC_RUNNER.new(:step_into => %w{ opsview_client }) do |node|
          node.automatic['filesystem']['/dev/mapper/vg00-Root'] = { fs_type: 'ext4', monut: '/'}
          node.automatic['macaddress'] = 'aa:bb:cc:dd:ee:ff'
      end.converge('opsview_client_test::test' )
    end

    it 'should call the opsview_client LWRP' do
        expect(chef_run).to add_or_update_opsview_client('chefspec.local')
    end
    it 'should call the OpsView REST API login method' do
      expect($api_login).to have_been_requested
    end
    it 'should call the OpsView REST API search method' do
      expect($api_search).to have_been_requested
    end
    it 'should call the OpsView REST API update method' do
      expect($api_update).to have_been_requested
    end
  end

  context "for an existing host with no updates" do
    before(:context) do
      WebMock.reset!
      $api_login = stub_request(:post, "http://uat.opsview.com/rest/login").
          with(:body => "{\"username\":\"userid\",\"password\":\"passw0rd\"}",
            :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'43', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => "{\"token\": \"moo\"}", :headers => {'Content-Type'=>'application/json'})

      $api_search = stub_request(:get, "http://uat.opsview.com/rest/config/host?json_filter=%7B%22name%22:%20%7B%22-like%22:%20%22chefspec.local%22%7D%7D").
         with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Opsview-Token'=>'moo', 'X-Opsview-Username'=>'userid'}).
         to_return(:status => 200, :body => '{"list": [ {"hosttemplates":[{"ref":"/rest/config/hosttemplate/36","name":"Network - Base"}],"snmpv3_privprotocol":null,"flap_detection_enabled":"1","keywords":[],"check_period":{"ref":"/rest/config/timeperiod/1","name":"24x7"},"hostattributes":[{"arg2":null,"arg1":"https://localhost:443","arg4":null,"value":"_default","arg3":null,"name":"CHEFSERVER","id":"17306"},{"arg2":null,"arg1":null,"arg4":null,"value":"/","arg3":null,"name":"DISK","id":"17303"},{"arg2":null,"arg1":null,"arg4":null,"value":"/boot","arg3":null,"name":"DISK","id":"17304"},{"arg2":null,"arg1":null,"arg4":null,"value":"aa-bb-cc-dd-ee-ff","arg3":null,"name":"MAC","id":"17305"}],"id":"62","notification_period":{"ref":"/rest/config/timeperiod/1","name":"24x7"},"ref":"/rest/config/host/62","notification_options":null,"tidy_ifdescr_level":"0","name":"chefspec.local","business_components":[],"rancid_vendor":null,"hostgroup":{"ref":"/rest/config/hostgroup/3","name":"Test_Hostgroup"},"enable_snmp":"0","monitored_by":{"ref":"/rest/config/monitoringserver/1","name":"Master Monitoring Server"},"alias":"Chef client test","parents":[],"uncommitted":"1","icon":{"name":"LOGO - Opsview","path":"/images/logos/opsview_small.png"},"retry_check_interval":"1","ip":"127.0.0.1","event_handler":"","use_mrtg":"0","snmp_max_msg_size":"2","servicechecks":[],"use_rancid":"0","snmp_version":"2c","nmis_node_type":"router","snmp_extended_throughput_data":"0","use_nmis":"0","rancid_connection_type":"ssh","snmpv3_authprotocol":null,"rancid_username":null,"check_command":{"ref":"/rest/config/hostcheckcommand/15","name":"ping"},"rancid_password":"","check_attempts":"2","check_interval":"0","notification_interval":"60","snmp_port":"161","snmpv3_username":"","other_addresses":""} ] }', 
                   :headers => {})

      $api_update = stub_request(:put, "http://uat.opsview.com/rest/config/host").
         with(:body => "{\"hosttemplates\":[{\"ref\":\"/rest/config/hosttemplate/36\",\"name\":\"Network - Base\"}],\"snmpv3_privprotocol\":null,\"flap_detection_enabled\":\"1\",\"keywords\":[],\"check_period\":{\"ref\":\"/rest/config/timeperiod/1\",\"name\":\"24x7\"},\"hostattributes\":[{\"arg2\":null,\"arg1\":\"https://localhost:443\",\"arg4\":null,\"value\":\"_default\",\"arg3\":null,\"name\":\"CHEFSERVER\",\"id\":\"17306\"},{\"arg2\":null,\"arg1\":null,\"arg4\":null,\"value\":\"/\",\"arg3\":null,\"name\":\"DISK\",\"id\":\"17303\"},{\"arg2\":null,\"arg1\":null,\"arg4\":null,\"value\":\"/boot\",\"arg3\":null,\"name\":\"DISK\",\"id\":\"17304\"},{\"arg2\":null,\"arg1\":null,\"arg4\":null,\"value\":\"aa-bb-cc-dd-ee-ff\",\"arg3\":null,\"name\":\"MAC\",\"id\":\"17305\"}],\"id\":\"62\",\"notification_period\":{\"ref\":\"/rest/config/timeperiod/1\",\"name\":\"24x7\"},\"ref\":\"/rest/config/host/62\",\"notification_options\":null,\"tidy_ifdescr_level\":\"0\",\"name\":\"chefspec.local\",\"business_components\":[],\"rancid_vendor\":null,\"hostgroup\":{\"name\":\"Test_Hostgroup\"},\"enable_snmp\":\"0\",\"monitored_by\":{\"name\":\"Master Monitoring Server\"},\"alias\":\"Chef client test\",\"parents\":[],\"uncommitted\":\"1\",\"icon\":{\"name\":\"LOGO - Opsview\",\"path\":\"/images/logos/opsview_small.png\"},\"retry_check_interval\":\"1\",\"ip\":\"127.0.0.1\",\"event_handler\":\"\",\"use_mrtg\":\"0\",\"snmp_max_msg_size\":\"2\",\"servicechecks\":[],\"use_rancid\":\"0\",\"snmp_version\":\"2c\",\"nmis_node_type\":\"router\",\"snmp_extended_throughput_data\":\"0\",\"use_nmis\":\"0\",\"rancid_connection_type\":\"ssh\",\"snmpv3_authprotocol\":null,\"rancid_username\":null,\"check_command\":{\"ref\":\"/rest/config/hostcheckcommand/15\",\"name\":\"ping\"},\"rancid_password\":\"\",\"check_attempts\":\"2\",\"check_interval\":\"0\",\"notification_interval\":\"60\",\"snmp_port\":\"161\",\"snmpv3_username\":\"\",\"other_addresses\":\"\"}",
              :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'1657', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Opsview-Token'=>'moo', 'X-Opsview-Username'=>'userid'}).
         to_return(:status => 200, :body => "{ }", :headers => {})
    end

    let(:chef_run) do
      CHEFSPEC_RUNNER.new(:step_into => %w{ opsview_client }) do |node|
          node.automatic['filesystem']['/dev/mapper/vg00-Root'] = { fs_type: 'ext4', monut: '/'}
          node.automatic['macaddress'] = 'aa:bb:cc:dd:ee:ff'
      end.converge('opsview_client_test::test' )
    end

    it 'should call the opsview_client LWRP' do
        expect(chef_run).to add_or_update_opsview_client('chefspec.local')
    end
    it 'should call the OpsView REST API login method' do
      expect($api_login).to have_been_requested
    end
    it 'should call the OpsView REST API search method' do
      expect($api_search).to have_been_requested
    end
    it 'should not call the OpsView REST API update method' do
      expect($api_update).not_to have_been_requested
    end
  end

  context "for an existing host with updates" do
    before(:context) do
      WebMock.reset!
      $api_login = stub_request(:post, "http://uat.opsview.com/rest/login").
          with(:body => "{\"username\":\"userid\",\"password\":\"passw0rd\"}",
            :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'43', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => "{\"token\": \"moo\"}", :headers => {'Content-Type'=>'application/json'})

      $api_search = stub_request(:get, "http://uat.opsview.com/rest/config/host?json_filter=%7B%22name%22:%20%7B%22-like%22:%20%22chefspec.local%22%7D%7D").
         with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Opsview-Token'=>'moo', 'X-Opsview-Username'=>'userid'}).
         to_return(:status => 200, :body => '{"list": [ {"hosttemplates":[{"ref":"/rest/config/hosttemplate/36","name":"Network - Base"}],"snmpv3_privprotocol":null,"flap_detection_enabled":"1","keywords":[],"check_period":{"ref":"/rest/config/timeperiod/1","name":"24x7"},"hostattributes":[{"arg2":null,"arg1":"https://localhost:8889","arg4":null,"value":"_default","arg3":null,"name":"CHEFSERVER","id":"17306"},{"arg2":null,"arg1":null,"arg4":null,"value":"/","arg3":null,"name":"DISK","id":"17303"},{"arg2":null,"arg1":null,"arg4":null,"value":"/boot","arg3":null,"name":"DISK","id":"17304"},{"arg2":null,"arg1":null,"arg4":null,"value":"08-00-27-70-C7-F1","arg3":null,"name":"MAC","id":"17305"}],"id":"62","notification_period":{"ref":"/rest/config/timeperiod/1","name":"24x7"},"ref":"/rest/config/host/62","notification_options":null,"tidy_ifdescr_level":"0","name":"client-centos-66.vagrantup.com","business_components":[],"rancid_vendor":null,"hostgroup":{"ref":"/rest/config/hostgroup/3","name":"Test_Hostgroup"},"enable_snmp":"0","monitored_by":{"ref":"/rest/config/monitoringserver/1","name":"Master Monitoring Server"},"alias":"Chef client test","parents":[],"uncommitted":"1","icon":{"name":"LOGO - Opsview","path":"/images/logos/opsview_small.png"},"retry_check_interval":"1","ip":"10.0.2.15","event_handler":"","use_mrtg":"0","snmp_max_msg_size":"2","servicechecks":[],"use_rancid":"0","snmp_version":"2c","nmis_node_type":"router","snmp_extended_throughput_data":"0","use_nmis":"0","rancid_connection_type":"ssh","snmpv3_authprotocol":null,"rancid_username":null,"check_command":{"ref":"/rest/config/hostcheckcommand/15","name":"ping"},"rancid_password":"","check_attempts":"2","check_interval":"0","notification_interval":"60","snmp_port":"161","snmpv3_username":"","other_addresses":""} ] }', 
                   :headers => {})

      $api_update = stub_request(:put, "http://uat.opsview.com/rest/config/host").
         with(:body => "{\"hosttemplates\":[{\"ref\":\"/rest/config/hosttemplate/36\",\"name\":\"Network - Base\"}],\"snmpv3_privprotocol\":null,\"flap_detection_enabled\":\"1\",\"keywords\":[],\"check_period\":{\"ref\":\"/rest/config/timeperiod/1\",\"name\":\"24x7\"},\"hostattributes\":[{\"arg2\":null,\"arg1\":\"https://localhost:443\",\"arg4\":null,\"value\":\"_default\",\"arg3\":null,\"name\":\"CHEFSERVER\",\"id\":\"17306\"},{\"arg2\":null,\"arg1\":null,\"arg4\":null,\"value\":\"/\",\"arg3\":null,\"name\":\"DISK\",\"id\":\"17303\"},{\"arg2\":null,\"arg1\":null,\"arg4\":null,\"value\":\"/boot\",\"arg3\":null,\"name\":\"DISK\",\"id\":\"17304\"},{\"arg2\":null,\"arg1\":null,\"arg4\":null,\"value\":\"aa-bb-cc-dd-ee-ff\",\"arg3\":null,\"name\":\"MAC\",\"id\":\"17305\"}],\"id\":\"62\",\"notification_period\":{\"ref\":\"/rest/config/timeperiod/1\",\"name\":\"24x7\"},\"ref\":\"/rest/config/host/62\",\"notification_options\":null,\"tidy_ifdescr_level\":\"0\",\"name\":\"chefspec.local\",\"business_components\":[],\"rancid_vendor\":null,\"hostgroup\":{\"name\":\"Test_Hostgroup\"},\"enable_snmp\":\"0\",\"monitored_by\":{\"name\":\"Master Monitoring Server\"},\"alias\":\"Chef client test\",\"parents\":[],\"uncommitted\":\"1\",\"icon\":{\"name\":\"LOGO - Opsview\",\"path\":\"/images/logos/opsview_small.png\"},\"retry_check_interval\":\"1\",\"ip\":\"127.0.0.1\",\"event_handler\":\"\",\"use_mrtg\":\"0\",\"snmp_max_msg_size\":\"2\",\"servicechecks\":[],\"use_rancid\":\"0\",\"snmp_version\":\"2c\",\"nmis_node_type\":\"router\",\"snmp_extended_throughput_data\":\"0\",\"use_nmis\":\"0\",\"rancid_connection_type\":\"ssh\",\"snmpv3_authprotocol\":null,\"rancid_username\":null,\"check_command\":{\"ref\":\"/rest/config/hostcheckcommand/15\",\"name\":\"ping\"},\"rancid_password\":\"\",\"check_attempts\":\"2\",\"check_interval\":\"0\",\"notification_interval\":\"60\",\"snmp_port\":\"161\",\"snmpv3_username\":\"\",\"other_addresses\":\"\"}",
              :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'1657', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Opsview-Token'=>'moo', 'X-Opsview-Username'=>'userid'}).
         to_return(:status => 200, :body => "{ }", :headers => {})
    end

    let(:chef_run) do
      CHEFSPEC_RUNNER.new(:step_into => %w{ opsview_client }) do |node|
          node.automatic['filesystem']['/dev/mapper/vg00-Root'] = { fs_type: 'ext4', monut: '/'}
          node.automatic['macaddress'] = 'aa:bb:cc:dd:ee:ff'
      end.converge('opsview_client_test::test' )
    end

    it 'should call the opsview_client LWRP' do
        expect(chef_run).to add_or_update_opsview_client('chefspec.local')
    end
    it 'should call the OpsView REST API login method' do
      expect($api_login).to have_been_requested
    end
    it 'should call the OpsView REST API search method' do
      expect($api_search).to have_been_requested
    end
    it 'should call the OpsView REST API update method' do
      expect($api_update).to have_been_requested
    end
  end

end
