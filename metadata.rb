name             'opsview_client'
maintainer       'Rob Coward'
maintainer_email 'rob@coward-family.net'
license          'Apache 2.0'
description      'Installs/Configures opsview agent'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.1'

depends 'build-essential', '~> 2.2.3'
depends 'yum', '~> 3.5.4'
depends 'yum-epel', '~> 0.6.0'
depends 'windows', '~> 1.37.0'

%w(redhat centos windows).each do |os|
  supports os
end
