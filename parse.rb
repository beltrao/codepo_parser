require 'sqlite3'

# Set up database schema and perform cleanup
puts 'Initializing DB'

@db = SQLite3::Database.new('postcodes.sqlite3')

# Codelist.xls
@db.execute 'DROP TABLE IF EXISTS es;'
@db.execute 'CREATE TABLE es (
  e TEXT PRIMARY KEY,
  name TEXT
);'

# Postcodes API
@db.execute 'DROP TABLE IF EXISTS areas;'
@db.execute 'CREATE TABLE areas (
  code TEXT PRIMARY KEY,
  lat double,
  lon double,
  town TEXT,
  region TEXT,
  country TEXT,
  district_id INTEGER
);'

@db.execute 'DROP TABLE IF EXISTS postcodes;'
@db.execute 'CREATE TABLE postcodes (
  code TEXT PRIMARY KEY,
  lat double,
  lon double
);'

puts 'DB Initialized'
