class Carrier < Sequel::Model(:carriers)
  unrestrict_primary_key
  
  def self.batch_import(hashes_array) # This should be optimized in postgresql
    hashes_array.each do |h|
      create(h) rescue Sequel::UniqueConstraintViolation
    end
  end
end