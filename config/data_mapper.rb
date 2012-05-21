require 'dm-core'
require 'dm-migrations'
require 'dm-validations'

DataMapper::Property::String.length(255)

DataMapper::Logger.new($stdout, :debug)
sqlite = 'sqlite://' + File.join(File.dirname(__FILE__), '../db/app.db')
DataMapper.setup(:default, sqlite)
