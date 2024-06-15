# typed: false
# frozen_string_literal: true

class Reader
  def self.read_file(file_path)
    File.open(file_path, "rb") do |database_file|
      header_data = database_file.read(100)
      header = Header.new(header_data)

      database_file.seek(0)

      pages = []
      header.page_count.times do
        data = database_file.read(header.page_size)
        pages << Page.new(data)
      end

      [header, pages]
    end
  end
end
