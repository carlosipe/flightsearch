class API
  attr_reader :api_key
  def initialize
    @api_key = Settings::SKYSCANNER_API_KEY
  end

  def build_url(opts)
    params = [:origin, :destination, :outbound_date]
    params.map!{|x| opts.fetch(x)}
    params << opts.fetch(:inbound_date) if opts[:second_time]
    "http://api.skyscanner.net/apiservices/browsequotes/v1.0/US/USD/en-US/#{params.join('/')}?apikey=#{api_key}"
  end

  def request(opts)
    url = build_url(opts)
    r = Requests.request("GET", url)
    
    Response.new(JSON.parse r.body)
  end

  def request_and_save(opts)
    response = request(opts)
    Carrier.batch_import response.carriers
    Place.batch_import response.places
    Quote.batch_import response.quotes
  end
end

class Response
  attr_reader :response
  def initialize(response)
    @response = response
  end

  def carriers
    response.fetch("Carriers").map do |carrier|
      {
        id:         carrier.fetch("CarrierId"),
        name:       carrier.fetch("Name")
      }
    end
  end

  def quotes
    response.fetch("Quotes").map do |quote|
      outbound = quote.fetch("OutboundLeg")
      inbound  = quote.fetch("InboundLeg") { nil }
      outbound_leg = {
        outbound_leg_carrier_ids: outbound.fetch('CarrierIds').join(' '),
        outbound_leg_origin_id: outbound.fetch('OriginId'),
        outbound_leg_destination_id: outbound.fetch('DestinationId'),
        outbound_leg_departure_date: outbound.fetch('DepartureDate')
      }
      inbound_leg = {}
      inbound_leg = {
        inbound_leg_carrier_ids: inbound.fetch('CarrierIds').join(' '),
        inbound_leg_origin_id: inbound.fetch('OriginId'),
        inbound_leg_destination_id: inbound.fetch('DestinationId'),
        inbound_leg_departure_date: inbound.fetch('DepartureDate')
      } if inbound
      {
        min_price: quote.fetch('MinPrice'),
        direct: quote.fetch('Direct'),
        quote_datetime: quote.fetch('QuoteDateTime')
      }.merge(outbound_leg).merge(inbound_leg)
    end
  end

  def places
    response.fetch("Places").map do |place|
      {
        id:               place.fetch("PlaceId"),
        iata_code:        place.fetch("IataCode") {},
        name:             place.fetch("Name"),
        type:             place.fetch("Type"),
        skyscanner_code:  place.fetch("SkyscannerCode"),
        city_name:        place.fetch("CityName") {},
        city_id:          place.fetch("CityId") {},
        country_name:     place.fetch("CountryName") {}
      }
    end
  end
end