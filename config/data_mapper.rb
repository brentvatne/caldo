require 'dm-core'
require 'dm-migrations'
require 'dm-validations'

DataMapper::Property::String.length(255)

if CALDO_ENV == 'test'
  DataMapper.setup(:default, 'sqlite::memory:')
else
  DataMapper::Logger.new($stdout, :debug)
  sqlite = 'sqlite://' + File.join(File.dirname(__FILE__), '../db/app.db')
  DataMapper.setup(:default, sqlite)
end
