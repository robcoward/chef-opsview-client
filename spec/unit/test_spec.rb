require 'spec_helper'

context "for a server with a single root filesystem" do

  describe 'opsview_client_test::test' do
    let(:chef_run) do
      ChefSpec::Runner.new(:step_into => %w{ opsview_client }) do |node|
          node.automatic['filesystem']['/dev/mapper/vg00-Root'] = { fs_type: 'ext4', monut: '/'}
          node.automatic['macaddress'] = 'aa:bb:cc:dd:ee'
      end.converge('opsview_client_test::test' )
    end

    it 'should call the opsview_client LWRP' do
        expect(chef_run).to add_or_update_opsview_client('client1.fqdn')
    end

  end

end
