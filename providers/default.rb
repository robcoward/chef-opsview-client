#
# Cookbook Name:: opsview_client
# Providers:: default
#
# Copyright 2014, Rob Coward
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'json'

@errorOccurred = false
#use_inline_resources if defined?(use_inline_resources)

action :add do
  new_resource.updated_by_last_action(do_add_or_update(:add))
end

action :add_or_update do
  new_resource.updated_by_last_action(do_add_or_update(:add_or_update))
end

action :update do
  new_resource.updated_by_last_action(do_add_or_update(:update))
end

def do_add_or_update(resource_action)
  require 'hashdiff'

  if @current_resource.json_data.nil?
    if resource_action == :update
      Chef::Log.info( "#{@new_resource.name} is not registered - skipping.")
      return false
    else
      Chef::Log.info( "#{@new_resource.name} is not registered - creating new registration.")
      @new_resource.json_data(new_registration())
      do_update = true
    end
  else
    if resource_action == :add 
      Chef::Log.info( "#{@new_resource.name} is already registered - skipping.")
      return false
    else
      Chef::Log.debug("current_resource Before update_host_details: #{@current_resource.json_data.inspect}")
      @new_resource.json_data(update_host_details(@current_resource.json_data))
      Chef::Log.debug("new_resource After update_host_details: #{@new_resource.json_data.inspect}")
      json_diff = HashDiff.diff(@current_resource.json_data, @new_resource.json_data)
      do_update = json_diff.size > 0 ? true : false
      Chef::Log.info( "#{@new_resource.name} updated: #{do_update} diff: #{json_diff.inspect}")
    end 
  end

  if do_update
    put_opsview_device

    if @new_resource.reload_opsview
      Chef::Log.info( "Configured to reload opsview")
      do_reload_opsview
    else
      Chef::Log.info( "Configured NOT to reload opsview" )
    end
  end

  do_update
end

def new_registration
  node_json = { }
  node['opsview']['default_node'].each_pair do |key,value|
    node_json[key] = value
  end

  update_host_details(node_json)
end

def update_host_details(original_json)
  node_json = Marshal.load(Marshal.dump(original_json))
  node_json["name"] = @new_resource.device_title
  node_json["ip"] = @new_resource.ip

  if not @new_resource.hostalias.to_s.empty?
    node_json["alias"] = @new_resource.hostalias
  end

  if node_json["hostgroup"]["name"] != @new_resource.hostgroup
    node_json["hostgroup"] = { "name" => @new_resource.hostgroup }
  end

  if node_json["hosttemplates"].nil?
    node_json["hosttemplates"] = []
  end
  node_json["hosttemplates"].synchronise_array_by_key(@new_resource.hosttemplates, 'name') 

  if not @new_resource.monitored_by.to_s.empty?
    if node_json["monitored_by"]["name"] != @new_resource.monitored_by
      node_json["monitored_by"] = { "name" => @new_resource.monitored_by }
    end
  end

  if node_json["keywords"].nil?
    node_json["keywords"] = []
  end
  node_json["keywords"].synchronise_array_by_key(@new_resource.keywords, 'name')

  if node_json["hostattributes"].nil?
    node_json["hostattributes"] = []
  end
  node_json["hostattributes"].synchronise_hash_by_key(get_host_attributes(), 'name')

  node_json
end

def get_host_attributes
  host_attributes = []
  node['filesystem'].each_pair do |fs,opts|
    if opts.attribute?('fs_type') and not node['opsview']['exclude_fs_type'].include?(opts['fs_type'])
      if not opts['mount'].to_s.empty?
        host_attributes << { "name" => "DISK", "value" => opts['mount'].gsub(':', '') }
      end
    end
  end

  if node['opsview']['optional_attributes'].include?('MAC')
    host_attributes << { "name" => "MAC", "value" => node['macaddress'].gsub(':', '-') }
  end

  if node['opsview']['optional_attributes'].include?('CHEFSERVER')
    host_attributes << { "name" => "CHEFSERVER", "value" => node.environment, "arg1" => Chef::Config[:chef_server_url] }
  end
  
  return host_attributes
end


# Check the OpsView Server to see the current state of the
# Device
def load_current_resource

  @current_resource = Chef::Resource::OpsviewClient.new(@new_resource.name)

  get_opsview_token()

  @current_resource.json_data(get_opsview_device())
  if @current_resource.json_data.nil?
    Chef::Log.info( "#{@new_resource.name} is not currently registered with OpsView" )
  else
    Chef::Log.debug( "Retrieved current details for #{@new_resource.name} from OpsView" )
  end
end
  
def api_url
  n = @new_resource
  url = "#{n.api_protocol}://#{n.api_host}:#{n.api_port}/rest"
end

def get_opsview_token
  require 'rest-client'

  Chef::Log.debug("Fetching Opsview token")
  post_body = { "username" => @new_resource.api_user,
                "password" => @new_resource.api_password }.to_json

  url = [ api_url(), "login" ].join("/")

  Chef::Log.debug( "Using Opsview url: " + url )
  Chef::Log.debug( "using post: username:" + @new_resource.api_user + " password:" + @new_resource.api_password.gsub(/\w/,'x') )

  begin
    response = RestClient.post url, post_body, :content_type => :json
  rescue
    @errorOccurred = true
    Chef::Log.fatal( "Problem getting token from Opsview server; " + $!.inspect )
    raise "Unable to authenticate with OpsView Rest API: " + $!.inspect
  end

  case response.code
  when 200
    Chef::Log.debug( "Response code: 200" )
  else
    Chef::Log.fatal( "Unable to log in to Opsview server; HTTP code " + response.code )
    raise "Error authenticating OpsView Rest API: " + response
  end

  received_token = JSON.parse(response)['token']
  Chef::Log.debug( "Got token: " + received_token )
  @new_resource.api_token(received_token)
end

def get_opsview_device
  require 'rest-client'

  if @new_resource.api_token.nil? 
    raise "OpsView Rest API token missing"
  end

  if @new_resource.name.nil?
    raise "Did not specify a node to look up."
  else
    url = URI.escape( [ api_url(), "config/host?json_filter={\"name\": {\"-like\": \"#{@new_resource.name}\"}}" ].join("/") ) 
  end

  begin
    response = RestClient.get url, :x_opsview_username => @new_resource.api_user, 
                                   :x_opsview_token => @new_resource.api_token, 
                                   :content_type => :json, 
                                   :accept => :json
  rescue
    raise "RestClient.get OpsView Rest API error: " + $!.inspect
  end

  begin
    responseJson = JSON.parse(response)
  rescue
    raise "Could not parse the JSON response from Opsview: " + response
  end

  obj = responseJson['list'][0]

  obj
end

def put_opsview_device
  require 'rest-client'

  if @errorOccurred 
    Chef::Log.warn( "put: Problem talking to Opsview server; ignoring Opsview config" )
    return
  end

  url = [ api_url(), "config/host" ].join("/")
  Chef::Log.debug("RestClient.put " + url + " : " + @new_resource.json_data.to_json)
  begin
    response = RestClient.put url, @new_resource.json_data.to_json, 
                              :x_opsview_username => @new_resource.api_user, 
                              :x_opsview_token => @new_resource.api_token, 
                              :content_type => :json, 
                              :accept => :json
  rescue
    Chef::Log.fatal( "Problem sending device data to Opsview server; " + $!.inspect + "\n====\n" + url + "\n====\n" + @new_resource.json_data.to_json )
    raise "RestClient.put OpsView Rest API errored: " + $!.inspect 
  end

  begin
    responseJson = JSON.parse(response)
  rescue
    raise "OpsView Rest API response is invalid: " + response
  end

  Chef::Log.debug("RestClient.put response: " + response)
end

def do_reload_opsview
  require 'rest-client'

  url = [ api_url(), "reload?asynchronous=1" ].join("/")

  Chef::Log.info( "Performing Opsview reload" )

  begin
    response = RestClient.post url, '', :x_opsview_username => @new_resource.api_user, 
                                        :x_opsview_token => @new_resource.api_token, 
                                        :content_type => :json, 
                                        :accept => :json
  rescue
    Chef::Log.warn( "Unable to reload Opsview: " + $!.inspect )
    return
  end

  case response.code
  when 200
    Chef::Log.debug( "Reloaded Opsview" )
  when 401
    raise "Login failed: " + response.code
  when 409
    Chef::Log.info( "Opsview reload already in progress" )
  else
    raise "Was not able to reload Opsview: HTTP code: " + response.code
  end
end

