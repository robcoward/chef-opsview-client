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

begin
  require 'rest-client'
  require 'json'
rescue LoadError => e
  nil
end
require 'yaml'  

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
  if @device.nil?
    if resource_action == :update
      Chef::Log.info( "#{@new_resource.name} is not registered - skipping.")
      return false
    else
      updated_json = new_registration()
      do_update = true
    end
  else
    if resource_action == :add 
      Chef::Log.info( "#{@new_resource.name} is already registered - skipping.")
      return false
    else
      updated_json = update_host_details(@device)
      do_update = @device == updated_json ? false : true
    end 
  end

  if do_update
    put updated_json

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

def update_host_details(node_json)
  node_json["name"] = @new_resource.device_title
  node_json["ip"] = @new_resource.ip

  if not @new_resource.hostalias.to_s.empty?
    node_json["alias"] = @new_resource.hostalias
  end

  node_json["hostgroup"] = { "name" => @new_resource.hostgroup }
  node_json["hosttemplates"] = []
  if @new_resource.hosttemplates
    @new_resource.hosttemplates.each do |ht|
      node_json["hosttemplates"] << {:name => ht}
    end
  end

  if not @new_resource.monitored_by.to_s.empty?
    node_json["monitored_by"] = { "name" => @new_resource.monitored_by }
  end

  node_json["keywords"] = []
  if @new_resource.keywords
    @new_resource.keywords.each do |kw|
      node_json["keywords"] << {:name => kw}
    end
  end

  node_json["hostattributes"] = get_host_attributes()

  node_json
end

# Check the OpsView Server to see the current state of the
# Device
def load_current_resource

  @token = get_token()
  @device = get_device()

end
  
def api_url
  n = @new_resource
  url = "#{n.api_protocol}://#{n.api_host}:#{n.api_port}/rest"
end

def get_token
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
    Chef::Log.warn( "Problem getting token from Opsview server; " + $!.inspect )
    return
  end

  case response.code
  when 200
    Chef::Log.debug( "Response code: 200" )
  else
    @errorOccurred = true
    Chef::Log.warn( "Unable to log in to Opsview server; HTTP code " + response.code )
    return
  end

  received_token = JSON.parse(response)['token']
  Chef::Log.debug( "Got token: " + received_token )
  received_token
end

def get_device
  if @errorOccurred 
    Chef::Log.warn( "get_resource: Problem talking to Opsview server; ignoring Opsview config" )
    return
  end

  if @new_resource.name.nil?
    raise "Did not specify a node to look up."
  else
    url = URI.escape( [ api_url(), "config/host?s.name=#{@new_resource.name}" ].join("/") )
  end

  begin
    response = RestClient.get url, :x_opsview_username => @new_resource.api_user, :x_opsview_token => @token, :content_type => :json, :accept => :json, :params => {:rows => :all}
  rescue
    @errorOccurred = true
    Chef::Log.warn( "get_resource: Problem talking to Opsview server; ignoring Opsview config: " + $!.inspect )
  end

  begin
    responseJson = JSON.parse(response)
  rescue
    raise "Could not parse the JSON response from Opsview: " + response
  end

  obj = responseJson['list'][0]

  obj
end

def put(body)
  if @errorOccurred 
    Chef::Log.warn( "put: Problem talking to Opsview server; ignoring Opsview config" )
    return
  end

  url = [ api_url(), "config/host" ].join("/")
  begin
    response = RestClient.put url, body.to_json, :x_opsview_username => @new_resource.api_user, :x_opsview_token => @token, :content_type => :json, :accept => :json
  rescue
    @errorOccurred = true
    Chef::Log.warn( "put_1: Problem sending data to Opsview server; " + $!.inspect + "\n====\n" + url + "\n====\n" + body.to_json )
    return
  end

  begin
    responseJson = JSON.parse(response)
  rescue
    @errorOccurred = true
    Chef::Log.warn( "put_2: Problem talking to Opsview server; ignoring Opsview config - " + $!.inspect )
    return
  end

  # if we get here, all should be ok, so make sure we mark as such.
  @errorOccurred = false
end

def do_reload_opsview
  url = [ api_url(), "reload?asynchronous=1" ].join("/")

  if @errorOccurred 
    Chef::Log.warn( "reload_opsview: Problem talking to Opsview server; ignoring Opsview config" )
    return
  end

  Chef::Log.info( "Performing Opsview reload" )

  begin
    response = RestClient.post url, '', :x_opsview_username => @new_resource.api_user, :x_opsview_token => @token, :content_type => :json, :accept => :json
  rescue
    @errorOccurred = true
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

def get_host_attributes
  host_attributes = []
  node['filesystem'].each_pair do |fs,opts|
    if opts.attribute?('fs_type') and not node['opsview']['exclude_fs_type'].include?(opts['fs_type'])
      if not opts['mount'].to_s.empty?
        host_attributes << { "name" => "DISK", "value" => opts['mount'].gsub(':', '') }
      end
    end
  end

  host_attributes << { "name" => "MAC", "value" => node['macaddress'].gsub(':', '-') }

  host_attributes << { "name" => "CHEFSERVER", "value" => node.environment, "arg1" => Chef::Config[:chef_server_url] }
  return host_attributes
end