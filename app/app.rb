require 'sinatra'
require 'sinatra/ratpack'
require 'sass'

module Caldo
  class App < Sinatra::Application
    enable :sessions

    set :client_id,     ENV['CALDO_GOOGLE_API_CLIENT_ID']
    set :client_secret, ENV['CALDO_GOOGLE_API_CLIENT_SECRET']

    set :app_root,      File.dirname(__FILE__)
    set :config_path,   File.join(settings.app_root, '../config/')
    set :scss_dir,      'assets/stylesheets'

    get '/assets/:file.css' do
      template = params[:file]
      if stylesheet_exists?(template)
        scss :"../#{settings.scss_dir}/#{template}"
      else
        halt 404
      end
    end

    private
    def stylesheet_exists?(asset)
      File.exists?(File.join(settings.app_root, "assets", "stylesheets", asset + ".scss"))
    end
  end
end
