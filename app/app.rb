require 'sinatra/base'
require 'sinatra/ratpack'
require 'sinatra/flash'
require 'sass'

module Caldo
  class App < Sinatra::Application
    enable :sessions

    set :client_id,     ENV['CALDO_GOOGLE_API_CLIENT_ID']
    set :client_secret, ENV['CALDO_GOOGLE_API_CLIENT_SECRET']

    enable :static
    set :root,          File.dirname(__FILE__)
    set :public_folder, File.dirname(__FILE__) + '/assets/static'
    set :scss_dir,     '/assets/dynamic/stylesheets'

    get '/stylesheets/:file.css' do
      template = params[:file]
      if stylesheet_exists?(template)
          scss :"../#{settings.scss_dir}/#{template}"
      else
        halt 404
      end
    end

    private
    def stylesheet_exists?(asset)
      File.exists?(File.join(settings.root, settings.scss_dir, asset + ".scss"))
    end
  end
end
