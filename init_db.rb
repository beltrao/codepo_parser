require 'sqlite3'

# Set up database schema and perform cleanup
puts 'Initializing DB'

@db = SQLite3::Database.new('postcodes.sqlite3')

# Codelist.xls
@db.execute 'CREATE TABLE IF NOT EXISTS es (
  e TEXT PRIMARY KEY,
  name TEXT
);'

# Postcodes API
@db.execute 'CREATE TABLE IF NOT EXISTS areas (
  code TEXT PRIMARY KEY,
  lat double,
  lon double,
  town TEXT,
  region TEXT,
  country TEXT,
  district_id INTEGER
);'

@db.execute 'CREATE TABLE IF NOT EXISTS postcodes (
  code TEXT PRIMARY KEY,
  lat double,
  lon double
);'

puts 'DB Initialized'
