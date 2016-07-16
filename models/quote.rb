class Quote < Sequel::Model(:quotes)
  many_to_one :outbound_leg_origin, key: :outbound_leg_origin_id, class: :Place
  many_to_one :outbound_leg_destination, key: :outbound_leg_destination_id, class: :Place
  many_to_one :inbound_leg_origin, key: :inbound_leg_origin_id, class: :Place
  many_to_one :inbound_leg_destination, key: :inbound_leg_destination_id, class: :Place

  def self.batch_import(hashes_array) # This should be optimized in postgresql
    hashes_array.each do |h|
      create(h) rescue Sequel::UniqueConstraintViolation
    end
  end

  def origin_name
    outbound_leg_origin.name
  end

  def destination_name
    outbound_leg_destination.name
  end
end