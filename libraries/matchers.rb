# opsview_client/libraries/matchers.rb
#

if defined?(ChefSpec)

    def add_opsview_client(resource_name)
        ChefSpec::Matchers::ResourceMatcher.new(:opsview_client, :add, resource_name)
    end

    def update_opsview_client(resource_name)
        ChefSpec::Matchers::ResourceMatcher.new(:opsview_client, :update, resource_name)
    end

    def add_or_update_opsview_client(resource_name)
        ChefSpec::Matchers::ResourceMatcher.new(:opsview_client, :add_or_update, resource_name)
    end

end