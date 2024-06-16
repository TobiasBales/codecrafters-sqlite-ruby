# typed: false
# frozen_string_literal: true

class Record
  include BufferBacked

  attr_reader :schema

  def initialize(data, schema)
    @data = data
    @schema = schema
  end

  def [](key)
    index = schema.find_index(key)
    raise "Trying to look up unknown key #{key.inspect} in #{schema.inspect}" unless index

    values[index]
  end

  def values
    @values ||= begin
      offset = header_size
      columns.map do |column|
        case column
        when 0
          nil
        when 1..7
          value = read(offset, column).unpack1("C")
          offset += column
          value
        when 8
          0
        when 9
          1
        when 10, 11
          raise "Serial types are not supported"
        else
          blob = column.even?
          length = column - 12
          length -= 1 if blob
          length /= 2

          value = read(offset, length)
          offset += length
          value
        end
      end
    end
  end

  private

  def header_size
    read_varint(0)
  end

  def header_offset
    varint_size(header_size)
  end

  def columns
    offset = header_offset
    columns = []

    while offset < header_size
      column = read_varint(offset)
      columns << column

      offset += varint_size(column)
    end

    columns
  end
end
