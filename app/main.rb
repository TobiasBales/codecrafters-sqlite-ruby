# typed: false
# frozen_string_literal: true

require_relative "buffer_backed"
require_relative "header"
require_relative "page"

database_file_path = ARGV[0]
command = ARGV[1]

if command == ".dbinfo"
  File.open(database_file_path, "rb") do |database_file|
    header_data = database_file.read(100)
    header = Header.new(header_data)
    header.print

    database_file.seek(0)

    pages = []
    header.page_count.times do
      data = database_file.read(header.page_size)
      pages << Page.new(data)
    end

    puts "number of tables:    #{pages.first.number_of_cells}"
  end
end
