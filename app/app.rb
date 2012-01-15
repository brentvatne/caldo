require 'sinatra'
require 'sinatra/ratpack'

module Caldo
  APP_ROOT     = File.expand_path(File.dirname(__FILE__))
  CONFIG_PATH  = File.expand_path(File.join(APP_ROOT, "../config/"))

  class App < Sinatra::Application
    enable :sessions
  end
end
