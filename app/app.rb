require 'sinatra/base'
require 'sinatra/ratpack'
require 'sinatra/flash'
require 'sass'
require 'coffee-script'

module Caldo
  # This portion of the app handles Sinatra configuration and asset
  # serving functionality.
  class App < Sinatra::Application
    enable :sessions
    enable :logging

    set :client_id,     ENV['GOOGLE_ID']
    set :client_secret, ENV['GOOGLE_SECRET']

    enable :static
    set :root,           File.dirname(__FILE__)
    set :dynamic_assets, File.dirname(__FILE__) + '/assets/dynamic'
    set :static_assets,  File.dirname(__FILE__) + '/assets/static'
    set :public_folder,  settings.static_assets
    set :scss_dir,       '/assets/dynamic/stylesheets'
    set :coffee_dir,     '/assets/dynamic/coffeescripts'

    # Both of these get requests are not even called if matching files are found
    # in the static assets directory
    get '/stylesheets/*.css' do
      template = params[:splat].first
      if stylesheet_exists?(template)
        scss :"../#{settings.scss_dir}/#{template}"
      else
        halt 404
      end
    end

    get '/javascripts/*.js' do
      coffee_file = params[:splat].first
      if coffeescript_exists?(coffee_file)
        coffee :"../#{settings.coffee_dir}/#{coffee_file}"
      else
        halt 404
      end
    end

    private
    # Checks the disk to see if the given filename exists as a scss spreadsheet
    #
    # Returns true if it does exist, false if not
    def stylesheet_exists?(asset)
      File.exists?(File.join(settings.root, settings.scss_dir, asset + ".scss"))
    end

    # Checks the disk to see if the given filename exists as coffeescript
    #
    # Returns true if it does exist, false if not
    def coffeescript_exists?(asset)
      File.exists?(File.join(settings.root, settings.coffee_dir, asset + ".coffee"))
    end
  end
end
