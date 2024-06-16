# typed: false
# frozen_string_literal: true

require_relative "buffer_backed"
require_relative "commands/db_info"
require_relative "commands/tables"
require_relative "cell"
require_relative "header"
require_relative "page"
require_relative "first_page"
require_relative "queries/count"
require_relative "query_parser"
require_relative "reader"
require_relative "record"
require_relative "schema_parser"

database_file_path = ARGV[0]
command = ARGV[1]

header, pages = Reader.read_file(database_file_path)
if command == ".dbinfo"
  puts Commands::DbInfo.new(header, pages).generate
elsif command == ".tables"
  puts Commands::Tables.new(header, pages).generate
else
  query_string = ARGV[1..].first
  query = QueryParser.parse(query_string)
  result = query.execute(pages)
  puts result
end
