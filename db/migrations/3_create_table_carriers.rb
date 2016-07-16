Sequel.migration do
  up do
    table = :carriers
    create_table table do
      Integer   :id, primary_key: true #7
      String    :name, null: false #"Vueling Airlines"
      DateTime  :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime  :updated_at
    end
    create_trigger(table, "trg_updated_at_#{table}", :set_updated_at, events: :update, each_row: true)
  end

  down do
    table = :carriers
    drop_trigger(table, "trg_updated_at_#{table}")
    drop_table table
  end
end