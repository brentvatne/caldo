require_relative 'spec_helper'
require 'capybara'
require 'capybara/dsl'

RSpec.configure do |config|
  config.include Capybara::DSL
end

Capybara.app = Caldo::App

# Helpers
# def login
#   visit '/'
#   click_link '..'
# end
