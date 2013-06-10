require 'roo'
require 'debugger'

load 'init_db.rb'

EXCLUDED_CODELIST_SHEETS = %w[Metadata AREA_CODES]
CODELIST_FILE = 'codepo_gb/Doc/Codelist.xls'

raise "#{CODELIST_FILE} not exists!" unless File.exists?(CODELIST_FILE)

codelist = Roo::Excel.new(CODELIST_FILE)

codelist.sheets.each do |sheet_name|
  next if EXCLUDED_CODELIST_SHEETS.include?(sheet_name)

  puts "Working on #{sheet_name}"
  codelist.default_sheet = sheet_name

  row_idx = 1
  while row_idx < codelist.last_row do
    name = codelist.cell(row_idx, 1)
    e = codelist.cell(row_idx, 2)
    query = "INSERT INTO es (e, name) VALUES ('#{e.gsub("'", "\\'")}', '#{name.gsub("'", "\\'")}');"
    begin
      @db.execute query
    rescue Exception => e
      puts 'Issues with query:'
      puts query
      puts e.message
    end

    row_idx += 1
  end
end

puts "Successfully parsed #{CODELIST_FILE}"
