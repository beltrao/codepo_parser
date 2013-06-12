require 'debugger'
require 'csv'

load 'init_db.rb'
load 'utils.rb'

DATA_DIR = 'codepo_gb_may_2013/Data/CSV'

Dir[File.join(File.dirname(__FILE__), DATA_DIR, "*.csv")].sort.each do |codes_csv_file|
  puts "Working on file #{codes_csv_file}"

  csv_table = CSV.read(codes_csv_file, quote_char: '"', col_sep: ',', row_sep: :auto, headers: true)

  csv_table.each do |row|
    # format is taken from Code-Point_Open_Column_Headers.csv
    postcode = row[0].gsub(' ', '')
    easting = row[2].to_i
    northing = row[3].to_i

    lat_lon = OsGridRef.new(easting, northing).to_latlon

    query = "INSERT INTO postcodes (code, lat, lon) VALUES ('#{postcode}', #{'%.5f' % lat_lon.lat}, #{'%.5f' % lat_lon.lon});"
    begin
      @db.execute query
      sleep 0.00001
    rescue Exception => ex
      puts "Issues with query #{query}:"
      puts ex.message
    end
  end

  puts "Successfully parsed file #{codes_csv_file}"
end

