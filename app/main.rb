# typed: false
# frozen_string_literal: true

require_relative "buffer_backed"
require_relative "commands/db_info"
require_relative "commands/tables"
require_relative "cell"
require_relative "header"
require_relative "page"
require_relative "reader"
require_relative "record"
require_relative "schema_parser"

database_file_path = ARGV[0]
command = ARGV[1]

if command == ".dbinfo"
  header, pages = Reader.read_file(database_file_path)

  puts Commands::DbInfo.new(header, pages).generate
elsif command == ".tables"
  header, pages = Reader.read_file(database_file_path)

  puts Commands::Tables.new(header, pages).generate
end
