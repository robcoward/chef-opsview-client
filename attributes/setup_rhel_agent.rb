# select the installation method for the Opsview agent
# the default 'repo' will set up a yum repo pointing to the Opsview Core repository
# set to 'local' if you want to handle the package repo yourself (e.g. if you're wrapping this cookbook and using a Satellite server)
default['opsview']['agent']['installation_method'] = 'repo'

# specify which packages (and specific versions, if needed) to install
default['opsview']['agent']['packages'] = {
  'libmcrypt' => nil,
  'opsview-agent' => nil
}

# config directory
default['opsview']['agent']['conf_dir'] = '/usr/local/nagios/etc'

# nrpe config parameters
default['opsview']['agent']['log_facility'] = 'daemon'
default['opsview']['agent']['pid_file'] = '/var/tmp/nrpe.pid'
default['opsview']['agent']['server_port'] = '5666'
default['opsview']['agent']['server_address'] = '0.0.0.0'
default['opsview']['agent']['nrpe_user'] = 'nagios'
default['opsview']['agent']['nrpe_group'] = 'nagios'
default['opsview']['agent']['allowed_hosts'] = '127.0.0.1'
default['opsview']['agent']['dont_blame_nrpe'] = '1'
default['opsview']['agent']['debug'] = '0'
default['opsview']['agent']['command_timeout'] = '60'
default['opsview']['agent']['connection_timeout'] = '300'
default['opsview']['agent']['allow_weak_random_seed'] = '1'
default['opsview']['agent']['include_dirs'] = [ "#{node['opsview']['agent']['conf_dir']}/nrpe_local" ]
default['opsview']['agent']['include_files'] = [ ]
default['opsview']['agent']['default_commands'] = true

