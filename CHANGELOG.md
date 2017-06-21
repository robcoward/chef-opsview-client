opsview_client CHANGELOG
========================

This file is used to list changes made in each version of the opsview_client cookbook.
1.0.6
-----
- Martin Lewis - Changed package resource to yum_package to allow package downgrade of opsview agent.
- Default is false and can be controlled via attribute default['yum']['yum_package']['allow_downgrade']

1.0.5
-----
- Martin Lewis - Guarded against flush_cache method not present in earlier versions of chef-client.

1.0.2
-----
- Tenyo Grozev - Add flush_cache to package installation in setup_rhel_agent.rb

1.0.1
-----
- Rob Coward - Removed version contraints from metadata.rb to allow newer versions to be used.

1.0.0
-----
- Rob Coward - Added Windows Agent installation and code tidy up read for release to Supermarket

0.3.0
-----
- Tenyo Grozev - Added setup_rhel_agent recipe; added build-essential, yum and yum-epel dependencies

0.2.1
-----
- Rob Coward - Fixed #3 where updates are not being passed to opsview

0.2.0
-----
- Rob Coward - Refactored to allow add and update actions to be used

0.1.0
-----
- Rob Coward - Initial release of opsview_client

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
