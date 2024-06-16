# typed: false
# frozen_string_literal: true

class Cell
  include BufferBacked

  attr_reader :page_type
  attr_reader :schema

  def initialize(data, page_type, schema)
    @data = data
    @page_type = page_type
    @schema = schema
  end

  def payload_size
    case page_type
    when :leaf_table, :leaf_index
      read_varint(0)
    when :interior_index
      read_varint(4)
    else
      raise "Unsupported page type #{page_type}"
    end
  end

  def payload_offset
    varint_size(payload_size)
  end

  def row_id
    case page_type
    when :leaf_table
      read_varint(payload_offset)
    when :interior_table
      read_varint(4)
    else
      raise "Unsupported page type #{page_type}"
    end
  end

  def row_id_offset
    varint_size(row_id)
  end

  def payload
    case page_type
    when :leaf_table
      read(payload_offset + row_id_offset, payload_size)
    when :leaf_index
      read(payload_offset, payload_size)
    when :interior_index
      read(payload_offset + 4, payload_size)
    else
      raise "Unsupported page type #{page_type}"
    end
  end

  def record
    Record.new(payload, schema)
  end
end
