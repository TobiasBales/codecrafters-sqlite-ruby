# typed: false
# frozen_string_literal: true

class Header
  include BufferBacked

  VALID_SCHEMA_FORMATS = [1, 2, 3, 4].freeze
  VALID_DATABASE_ENCODINGS = [1, 2, 3].freeze
  ENCODINGS = { 1 => "utf8", 2 => "utf16le", 3 => "utf16be" }.freeze

  def initialize(data)
    @data = data
    raise "Invalid header string #{header_string.inspect}" unless header_string == "SQLite format 3\0"

    unless maximum_embedded_payload_fraction == 64
      raise "Invalid maximum_embedded_payload_fraction #{maximum_embedded_payload_fraction}"
    end

    unless minimum_embedded_payload_fraction == 32
      raise "Invalid minimum_embedded_payload_fraction #{minimum_embedded_payload_fraction}"
    end

    raise "Invalid leaf_payload_fraction #{leaf_payload_fraction}" unless leaf_payload_fraction == 32

    raise "Invalid schema format #{schema_format}" unless VALID_SCHEMA_FORMATS.include?(schema_format)

    raise "Invalid database encoding #{database_encoding}" unless VALID_DATABASE_ENCODINGS.include?(database_encoding)

    raise unless reserved.each { |b| b == 0 }
  end

  def header_string
    read_string(0, 16)
  end

  def page_size
    read_int(16)
  end

  def write_format
    read_byte(18)
  end

  def read_format
    read_byte(19)
  end

  def reserved_bytes
    read_byte(20)
  end

  def maximum_embedded_payload_fraction
    read_byte(21)
  end

  def minimum_embedded_payload_fraction
    read_byte(22)
  end

  def leaf_payload_fraction
    read_byte(23)
  end

  def file_change_counter
    read_long(24)
  end

  def page_count
    read_long(28)
  end

  def freelist_trunk_page
    read_long(32)
  end

  def freelist_page_count
    read_long(36)
  end

  def schema_cookie
    read_long(40)
  end

  def schema_format
    read_long(44)
  end

  def default_page_cache_size
    read_long(48)
  end

  def largest_root_page
    read_long(52)
  end

  def database_encoding
    read_long(56)
  end

  def database_encoding_string
    ENCODINGS[database_encoding]
  end

  def user_version
    read_long(60)
  end

  def incremental_vacuum
    read_long(64)
  end

  def application_id
    read_long(68)
  end

  def reserved
    read_bytes(72, 20)
  end

  def version_valid_for_number
    read_long(92)
  end

  def sqlite_version
    read_long(96)
  end
end
