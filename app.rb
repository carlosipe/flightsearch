require 'pg'
require 'sequel'
require "requests"
require 'json'
require_relative './settings'
DB = Sequel.connect(Settings::POSTGRESQL_URL)

Dir["./models/**/*.rb"].each  { |rb| require rb }

# API.new.request_and_save(origin: 'ES', destination: 'BR', outbound_date: '2016-08') #optional: inbound_date