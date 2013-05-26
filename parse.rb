require 'sqlite3'

puts 'Initializing DB'

@db = SQLite3::Database.new('postcodes.sqlite3')

# Set up database schema and perform cleanup
@db.execute 'DROP TABLE IF EXISTS postcodes;'

@db.execute 'CREATE TABLE postcodes (code TEXT PRIMARY KEY, lat double, lon double);'
