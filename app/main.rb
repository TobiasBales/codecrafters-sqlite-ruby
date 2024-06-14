# typed: false
# frozen_string_literal: true

require_relative "header"

database_file_path = ARGV[0]
command = ARGV[1]

if command == ".dbinfo"
  File.open(database_file_path, "rb") do |database_file|
    puts "Logs from your program will appear here"

    header = Header.from(database_file)
    header.print
  end
end
