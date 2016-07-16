Sequel.migration do
  up do
    table = :quotes
    create_table table do
      Serial    :id, primary_key: true
      BigDecimal:min_price, size: [12, 2] #223.0 # numeric(12, 2)
      Boolean   :direct # false
      
      String    :outbound_leg_carrier_ids #TODO: make this an array http://blog.2ndquadrant.com/postgresql-9-3-development-array-element-foreign-keys/
      Integer   :outbound_leg_origin_id #40101
      Integer   :outbound_leg_destination_id #88915
      DateTime  :outbound_leg_departure_date # "DepartureDate"=>"2016-10-10T00:00:00"},

      String    :inbound_leg_carrier_ids #TODO: make this an array http://blog.2ndquadrant.com/postgresql-9-3-development-array-element-foreign-keys/
      Integer   :inbound_leg_origin_id #40101
      Integer   :inbound_leg_destination_id #88915
      DateTime  :inbound_leg_departure_date # "DepartureDate"=>"2016-10-10T00:00:00"},

      DateTime  :quote_datetime #"QuoteDateTime"=>"2016-07-13T13:27:00"}
      DateTime  :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime  :updated_at
      index [
        :min_price, :direct,
        :outbound_leg_carrier_ids, :outbound_leg_origin_id,
        :outbound_leg_destination_id, :outbound_leg_departure_date,
        :quote_datetime
      ], unique: true
    end
    create_trigger(table, "trg_updated_at_#{table}", :set_updated_at, events: :update, each_row: true)
  end

  down do
    table = :quotes
    drop_trigger(table, "trg_updated_at_#{table}")
    drop_table table
  end
end