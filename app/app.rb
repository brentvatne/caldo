require 'sinatra'
require 'sinatra/ratpack'

module Caldo
  class App < Sinatra::Application
    enable :sessions

    set :app_root,      File.dirname(__FILE__)
    set :config_path,   File.join(settings.app_root, "../config/")
    set :client_id,     ENV["CALDO_GOOGLE_API_CLIENT_ID"]
    set :client_secret, ENV["CALDO_GOOGLE_API_CLIENT_SECRET"]
  end
end
