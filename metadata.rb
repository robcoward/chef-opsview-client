name             'opsview_client'
maintainer       'Rob Coward'
maintainer_email 'rob@coward-family.net'
license          'Apache 2.0'
description      'Installs/Configures opsview agent'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.6'

depends 'build-essential'
depends 'yum'
depends 'yum-epel'
depends 'windows'

%w(redhat centos windows).each do |os|
  supports os
end
