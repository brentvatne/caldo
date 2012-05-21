require_relative '../spec_helper'

module Caldo
  class App < Sinatra::Application
    set(:authenticates) do |required|
      condition { true }
    end
  end
end
