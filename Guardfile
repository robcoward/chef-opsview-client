#guard "foodcritic", :cookbook_paths => ".", :all_on_start => false do  
#  watch(%r{attributes/.+\.rb$})
#  watch(%r{providers/.+\.rb$})
#  watch(%r{recipes/.+\.rb$})
#  watch(%r{resources/.+\.rb$})
#  watch(%r{^templates/(.+)})
#  watch('metadata.rb')
#end  

# Note: The cmd option is now required due to the increasing number of ways
#       rspec may be run, below are examples of the most common uses.
#  * bundler: 'bundle exec rspec'
#  * bundler binstubs: 'bin/rspec'
#  * spring: 'bin/rsspec' (This will use spring if running and you have
#                          installed the spring binstubs per the docs)
#  * zeus: 'zeus rspec' (requires the server to be started separetly)
#  * 'just' rspec: 'rspec'
guard :rspec, cmd: 'chef exec rspec --color' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{attributes/.+\.rb$})
  watch(%r{providers/.+\.rb$})
  watch(%r{^(recipes)/(.+)\.rb$})   { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{resources/.+\.rb$})
  watch(%r{test/.+})
  watch(%r{^files/(.+)})
  watch(%r{^templates/(.+)})
end

#guard 'kitchen' do
#  watch(%r{test/.+})
#  watch(%r{^recipes/(.+)\.rb$})
#  watch(%r{^attributes/(.+)\.rb$})
#  watch(%r{^files/(.+)})
#  watch(%r{^templates/(.+)})
#  watch(%r{^providers/(.+)\.rb})
#  watch(%r{^resources/(.+)\.rb})
#end

