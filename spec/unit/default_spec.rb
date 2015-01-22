require 'spec_helper'

describe 'opsview_client::default' do
  let(:chef_run) { CHEFSPEC_RUNNER.new.converge(described_recipe) }

  it 'installs rest-client gem' do
    expect(chef_run).to install_chef_gem('rest-client')
  end

  it 'installs hashdiff gem' do
    expect(chef_run).to install_chef_gem('hashdiff')
  end 

end
