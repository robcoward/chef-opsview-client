require 'spec_helper'

describe 'opsview_client::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs rest-client gem' do
    expect(chef_run).to install_chef_gem('rest-client')
  end

end
