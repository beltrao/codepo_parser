require 'debugger'

load 'init_db.rb'

export_sql = File.open('export.pgsql', 'w')

postcodes = @db.execute 'select * from postcodes'

postcodes.each do |code, lat, lon|
  export_sql.write "INSERT INTO postcodes(code, lat,lon) VALUES ('#{code}', #{lat}, #{lon}) WHERE NOT EXISTS (SELECT * FROM postcodes WHERE code='#{code}');"
end

export_sql.close
puts 'Exported to export.pgsql'


