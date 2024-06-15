# typed: false
# frozen_string_literal: true

class Header
  VALID_SCHEMA_FORMATS = [1, 2, 3, 4].freeze
  VALID_DATABASE_ENCODINGS = [1, 2, 3].freeze
  ENCODINGS = { 1 => "utf8", 2 => "utf16le", 3 => "utf16be" }.freeze

  class << self
    def from(file)
      header_string = file.read(16).unpack("C*").pack("C*")
      raise "Invalid header string #{header_string}" unless header_string == "SQLite format 3\0"

      page_size = file.read(2).unpack1("n")
      write_format = file.read(1).unpack1("C")
      read_format = file.read(1).unpack1("C")
      reserved_bytes = file.read(1).unpack1("C")
      maximum_embedded_payload_fraction = file.read(1).unpack1("C")
      unless maximum_embedded_payload_fraction == 64
        raise "Invalid maximum_embedded_payload_fraction #{maximum_embedded_payload_fraction}"
      end

      minimum_embedded_payload_fraction = file.read(1).unpack1("C")
      unless minimum_embedded_payload_fraction == 32
        raise "Invalid minimum_embedded_payload_fraction #{minimum_embedded_payload_fraction}"
      end

      leaf_payload_fraction = file.read(1).unpack1("C")
      raise "Invalid leaf_payload_fraction #{leaf_payload_fraction}" unless minimum_embedded_payload_fraction == 32

      file_change_counter = file.read(4).unpack1("N")
      page_count = file.read(4).unpack1("N")
      freelist_trunk_page = file.read(4).unpack1("N")
      freelist_page_count = file.read(4).unpack1("N")
      schema_cookie = file.read(4).unpack1("N")
      schema_format = file.read(4).unpack1("N")
      raise "Invalid schema format #{schema_format}" unless VALID_SCHEMA_FORMATS.include?(schema_format)

      default_page_cache_size = file.read(4).unpack1("N")
      largest_root_page = file.read(4).unpack1("N")
      database_encoding = file.read(4).unpack1("N")
      raise "Invalid database encoding #{database_encoding}" unless VALID_DATABASE_ENCODINGS.include?(database_encoding)

      user_version = file.read(4).unpack1("N")
      incremental_vacuum = file.read(4).unpack1("N")
      application_id = file.read(4).unpack1("N")
      reserved = file.read(20).unpack("C*")
      raise unless reserved.each { |b| b == 0 }

      version_valid_for_number = file.read(4).unpack1("N")
      sqlite_version = file.read(4).unpack1("N")

      new(
        page_size:,
        write_format:,
        read_format:,
        reserved_bytes:,
        file_change_counter:,
        page_count:,
        freelist_trunk_page:,
        freelist_page_count:,
        schema_cookie:,
        schema_format:,
        default_page_cache_size:,
        largest_root_page:,
        database_encoding:,
        user_version:,
        incremental_vacuum:,
        application_id:,
        reserved:,
        version_valid_for_number:,
        sqlite_version:,
      )
    end
  end

  def initialize(
    page_size:,
    write_format:,
    read_format:,
    reserved_bytes:,
    file_change_counter:,
    page_count:,
    freelist_trunk_page:,
    freelist_page_count:,
    schema_cookie:,
    schema_format:,
    default_page_cache_size:,
    largest_root_page:,
    database_encoding:,
    user_version:,
    incremental_vacuum:,
    application_id:,
    reserved:,
    version_valid_for_number:,
    sqlite_version:
  )
    @page_size = page_size
    @write_format = write_format
    @read_format = read_format
    @reserved_bytes = reserved_bytes
    @file_change_counter = file_change_counter
    @page_count = page_count
    @freelist_trunk_page = freelist_trunk_page
    @freelist_page_count = freelist_page_count
    @schema_cookie = schema_cookie
    @schema_format = schema_format
    @default_page_cache_size = default_page_cache_size
    @largest_root_page = largest_root_page
    @database_encoding = database_encoding
    @user_version = user_version
    @incremental_vacuum = incremental_vacuum
    @application_id = application_id
    @reserved = reserved
    @version_valid_for_number = version_valid_for_number
    @sqlite_version = sqlite_version
  end

  def print
    puts "database page size:  #{@page_size}"
    puts "write format:        #{@write_format}"
    puts "read format:         #{@read_format}"
    puts "reserved bytes:      #{@reserved_bytes}"
    puts "file change counter: #{@file_change_counter}"
    puts "database page count: #{@page_count}"
    puts "freelist page count: #{@freelist_page_count}"
    puts "schema cookie:       #{@schema_cookie}"
    puts "schema format:       #{@schema_format}"
    puts "default cache size:  #{@default_page_cache_size}"
    puts "autovacuum top root: #{@largest_root_page}"
    puts "incremental vacuum:  #{@incremental_vacuum}"
    puts "text encoding:       #{@database_encoding} (#{ENCODINGS[@database_encoding]})"
    puts "user version:        #{@user_version}"
    puts "application id:      #{@application_id}"
    puts "software version:    #{@sqlite_version}"
  end
end
