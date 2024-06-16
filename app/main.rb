# typed: false
# frozen_string_literal: true

require_relative "buffer_backed"
require_relative "commands/db_info"
require_relative "header"
require_relative "reader"
require_relative "page"

database_file_path = ARGV[0]
command = ARGV[1]

if command == ".dbinfo"
  header, pages = Reader.read_file(database_file_path)

  puts Commands::DbInfo.new(header, pages.first).generate
end
