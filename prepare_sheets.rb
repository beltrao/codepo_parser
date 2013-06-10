require 'roo'
require 'debugger'

load 'init_db.rb'

EXCLUDED_CODELIST_SHEETS = %w[Metadata AREA_CODES]
codelist_spreadsheet = Roo::Excel.new('codepo_gb/Doc/Codelist.xls')

codelist_spreadsheet.sheets.each do |codelist_sheet_name|
  next if EXCLUDED_CODELIST_SHEETS.include?(codelist_sheet_name)

  puts "Working on #{codelist_sheet_name}"
  codelist_spreadsheet.default_sheet = codelist_sheet_name

  row_idx = 1
  while row_idx < codelist_spreadsheet.last_row do
    name = codelist_spreadsheet.cell(row_idx, 1)
    e = codelist_spreadsheet.cell(row_idx, 2)
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

puts 'Successfully parsed "codepo_gb/Doc/Codelist.xls"'
