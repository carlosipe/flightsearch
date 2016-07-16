Sequel.migration do
  up {
    DB.create_function(:set_updated_at, <<-SQL, :language=>:plpgsql, :returns=>:trigger)
      BEGIN
        NEW.updated_at := CURRENT_TIMESTAMP;
        RETURN NEW;
      END;
    SQL
  }

  down {
    DB.drop_function(:set_updated_at)
  }
end
