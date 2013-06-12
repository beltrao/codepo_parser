require 'roo'
require 'debugger'

load 'init_db.rb'

EXCLUDED_CODELIST_SHEETS = %w[Metadata AREA_CODES]
DATA_DIR = 'codepo_gb_may_2013/Doc'
CODELIST_FILES = %w[Codelist.xls NHS_Codelist.xls]

CODELIST_FILES.each do |file_name|
  puts "Working on file #{file_name}"

  file_path = File.join(DATA_DIR, file_name)

  raise "#{file_name} not exists!" unless File.exists?(file_path)

  codelist = Roo::Excel.new(file_path)

  codelist.sheets.each do |sheet_name|
    next if EXCLUDED_CODELIST_SHEETS.include?(sheet_name)

    puts "Working on sheet #{sheet_name}"
    codelist.default_sheet = sheet_name

    row_idx = 1
    while row_idx < codelist.last_row do
      name = codelist.cell(row_idx, 1)
      e_value = codelist.cell(row_idx, 2)
      query = "INSERT INTO es (e, name) VALUES ('#{e_value.gsub("'", "\\'")}', '#{name.gsub("'", "\\'")}');"
      begin
        @db.execute query
      rescue Exception => ex
        puts "Issues with query #{query}:"
        puts ex.message
      end

      row_idx += 1
    end

    puts "Successfully parsed sheet #{sheet_name}"
  end
  puts "Successfully parsed file #{file_name}"
end

