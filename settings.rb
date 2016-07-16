module Settings
  File.read(".env").scan(/(.*?)="?(.*)"?$/).each do |key, value|
    ENV[key] ||= value
  end
  POSTGRESQL_URL      = ENV.fetch("POSTGRESQL_URL")
  SKYSCANNER_API_KEY  = ENV.fetch("SKYSCANNER_API_KEY")
  RACK_SECRET         = ENV.fetch("RACK_SECRET")
end