Sequel.migration do
  up do
    table = :places
    create_table table do
      Integer   :id, null: false, primary_key: true #40101
      String    :name, null: false #=>"Lanzarote",
      String    :iata_code #=>"ACE",
      String    :type #=>"Station",
      String    :skyscanner_code #=>"ACE",
      String    :city_name #=>"Lanzarote",
      String    :city_id #=>"ARRE",
      String    :country_name #=>"Spain"}
      DateTime  :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime  :updated_at
    end
    create_trigger(table, "trg_updated_at_#{table}", :set_updated_at, events: :update, each_row: true)
  end

  down do
    table = :places
    drop_trigger(table, "trg_updated_at_#{table}")
    drop_table table
  end
end