class TargetExtractor
  def initialize file, prefix
    @file, @prefix = file, prefix.gsub(/[^\d]/, '')
  end

  def extract
    sheet_from_file(@file).rows.map do |row|
      company_name = row[1]
      public_phones = extract_phones row[2], @prefix
      last_phone = extract_phones row[3], @prefix
      [company_name, public_phones, last_phone]
    end
  end

  def convert_phone phone, prefix
    digits = phone.gsub(/[\s\(\)-]/, '')
    digits = digits[-([digits.length, 10].min)..-1]
    "+#{prefix[0..(10-digits.length)]}#{digits}"[0..11]
  end

  def extract_phones phones, prefix
    return if phones.nil?
    phones.scan(/((\d+[-\(\)]{,1}[\s]{,1})+)/).map(&:first).map do |phone|
      convert_phone phone, prefix
    end
  end

  def sheet_from_file file
    extension = file[:filename].split('.').last
    if extension == 'xlsx'
      new_name = "#{file[:tempfile].path}.#{extension}"
      FileUtils.mv file[:tempfile], new_name 
      XLSheet.new Excelx.new(new_name)
    elsif extension == 'xls'
      new_name = "#{file[:tempfile].path}.#{extension}"
      FileUtils.mv file[:tempfile], new_name 
      XLSheet.new Excel.new(new_name)
    elsif extension == 'csv'
      CSVSheet.new File.new(file[:tempfile].path).read
    else
      nil
    end
  end
end

class Sheet
  def initialize sheet
    @sheet = sheet
  end
end

class XLSheet < Sheet
  COLUMNS = ('A'..'Z').to_a.freeze

  def rows
    Enumerator.new do |row|
      @sheet.last_row.times do |row_number|
        row << Row.new(@sheet, row_number)
      end
    end
  end

  class Row
    def initialize sheet, row_number
      @sheet, @row_number = sheet, row_number
    end

    def [] column_number
      @sheet.cell @row_number, COLUMNS[column_number]
    end
  end
end

class CSVSheet < Sheet
  def rows
    CSV.parse(@sheet)
  end
end
