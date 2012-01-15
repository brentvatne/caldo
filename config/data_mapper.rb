require 'dm-core'
require 'dm-migrations'
require 'dm-validations'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default,
           'sqlite://' + File.join(File.dirname(__FILE__), '../db/app.db'))
