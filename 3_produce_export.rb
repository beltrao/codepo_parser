require 'debugger'

load 'init_db.rb'

export_sql = File.open('export.pgsql', 'w')

postcodes = @db.execute 'select * from postcodes'

postcodes.each do |code, lat, lon|
  export_sql.write "INSERT INTO postcodes_codepo_gb_may_2013(code, lat,lon) VALUES ('#{code}', #{lat}, #{lon});"
end

export_sql.close
puts 'Exported to export.pgsql'


