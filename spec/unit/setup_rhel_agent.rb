require_relative '../spec_helper.rb'

describe 'opsview_client::setup_rhel_agent' do

  let(:chef_run) { ChefSpec::SoloRunner.new do |node|
    node.automatic['platform_family'] = 'rhel'
  end.converge(described_recipe) }

  packages = %w{ libmcrypt opsview-agent }
  packages.each do |pkg|
    it "installs package #{pkg}" do
      expect(chef_run).to install_package(pkg)
    end
  end

  it "creates nrpe.cfg template" do
    expect(chef_run).to create_template('/usr/local/nagios/etc/nrpe.cfg')
  end

  it "starts service opsview-agent" do
    expect(chef_run).to start_service("opsview-agent")
  end

end
