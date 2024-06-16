# typed: false
# frozen_string_literal: true

module Commands
  class DbInfo
    def initialize(header, pages)
      @header = header
      @pages = pages
    end

    def generate
      info = +""
      info << "database page size:  #{@header.page_size}\n"
      info << "write format:        #{@header.write_format}\n"
      info << "read format:         #{@header.read_format}\n"
      info << "reserved bytes:      #{@header.reserved_bytes}\n"
      info << "file change counter: #{@header.file_change_counter}\n"
      info << "database page count: #{@header.page_count}\n"
      info << "freelist page count: #{@header.freelist_page_count}\n"
      info << "schema cookie:       #{@header.schema_cookie}\n"
      info << "schema format:       #{@header.schema_format}\n"
      info << "default cache size:  #{@header.default_page_cache_size}\n"
      info << "autovacuum top root: #{@header.largest_root_page}\n"
      info << "incremental vacuum:  #{@header.incremental_vacuum}\n"
      info << "text encoding:       #{@header.database_encoding} (#{@header.database_encoding_string})\n"
      info << "user version:        #{@header.user_version}\n"
      info << "application id:      #{@header.application_id}\n"
      info << "software version:    #{@header.sqlite_version}\n"
      info << "number of tables:    #{@pages.first.number_of_cells}\n"
    end
  end
end
