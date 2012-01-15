require 'dm-core'
require 'dm-migrations'
require 'dm-validations'

DataMapper::Logger.new($stdout, :debug)

sqlite = 'sqlite://' + File.join(File.dirname(__FILE__), '../db/app.db')
DataMapper.setup(:default, ENV['DATABASE_URL'] || sqlite)
