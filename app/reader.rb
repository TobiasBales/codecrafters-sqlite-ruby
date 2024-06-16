# typed: false
# frozen_string_literal: true

class Reader
  class << self
    def read_file(file_path)
      File.open(file_path, "rb") do |database_file|
        header_data = database_file.read(100)
        header = Header.new(header_data)

        database_file.seek(0)

        pages = []
        schema_storage = {}

        header.page_count.times do |i|
          data = database_file.read(header.page_size)
          if pages.empty?
            first_page = FirstPage.new(data)
            pages << first_page

            first_page.cells.each do |cell|
              _table_name, schema = SchemaParser.parse(cell.record[:sql])
              schema_storage[cell.record[:root_page]] = schema
            end
          else
            schema = schema_storage[i + 1]
            raise "Could not find schema at for page #{i + 1}" unless schema

            pages << Page.new(data, schema)
          end
        end

        [header, pages]
      end
    end
  end
end
