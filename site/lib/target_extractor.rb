class TargetExtractor
  def initialize file, prefix
    @file, @prefix = file, prefix.gsub(/[^\d]/, '')
  end

  def extract
    sheet_from_file(@file).rows.map do |row|
      company_name = row[1]
      public_phones = extract_phones row[2], @prefix
      ceo_phones = extract_phones row[3], @prefix
      ceo_name = extract_name row[3]
      [company_name, public_phones, ceo_phones, ceo_name]
    end
  end

  def normalize_phone phone, prefix
    digits = phone.gsub(/[^\d]/, '')
    digits = digits[-([digits.length, 10].min)..-1]
    "+#{prefix[0..(10-digits.length)]}#{digits}"[0..11]
  end

  def extract_phones phones, prefix
    return [] if phones.nil? or phones.empty?
    phones.scan(/([\+]*(\d+[-\(\)]{,1}[\s]{,1})+)/).map(&:first).map do |phone|
      normalize_phone phone, prefix
    end
  end

  def extract_name phones
    return '' if phones.nil? or phones.empty?
    name = phones.dup
    phones.scan(/([\+]*(\d+[-\(\)]{,1}[\s]{,1})+)/).map(&:first).each do |phone|
      name.gsub! phone, ''
    end
    name
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
      # CSVSheet.new File.new(file[:tempfile].path).read
      CSVSheet.new file[:tempfile].read.force_encoding Encoding::UTF_8
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
