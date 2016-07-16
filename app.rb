require 'pg'
require 'sequel'
require "requests"
require 'json'
require "cuba"
require "cuba/safe"
require "mote"
require "mote/render"
require_relative './settings'
DB = Sequel.connect(Settings::POSTGRESQL_URL)

Dir["./models/**/*.rb"].each  { |rb| require rb }

Cuba.use Rack::Static, :urls => ["/css", "/js"], :root => "public"
Cuba.plugin(Mote::Render)
Cuba.use Rack::Session::Cookie, secret: Settings::RACK_SECRET
Cuba.plugin Cuba::Safe
Dir["./routes/**/*.rb"].each  { |rb| require rb }

Cuba.define do
  on root do
    render 'index',
    quotes: Quote.eager(:outbound_leg_origin, :outbound_leg_destination).order_by(:min_price, :outbound_leg_departure_date).all
  end

  on 'places' do
    render 'places', places: Place.order_by(:country_name).all
  end
end

# countries = %w(ES FR AR GR IT)
# countries.each do |origin|
#   countries.each do |destination|
#     ['2016-07','2016-08'].each do |date|
#       API.new.request_and_save(origin: origin, destination: destination, outbound_date: date) #optional: inbound_date
#     end
#   end
# end

# API.new.request_and_save(origin: 'ES', destination: 'BR', outbound_date: '2016-08') #optional: inbound_date