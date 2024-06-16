# typed: false
# frozen_string_literal: true

class Page
  include BufferBacked

  attr_reader :schema

  def initialize(data, schema)
    @data = data
    @schema = schema
  end

  def type
    read_byte(0)
  end

  def page_type
    case type
    when 2
      :interior_index
    when 5
      :interior_table
    when 10
      :leaf_index
    when 13
      :leaf_table
    end
  end

  def page_header_offset
    case page_type
    when :interior_index, :interior_table
      12
    when :leaf_index, :leaf_table
      8
    else
      raise "Unsupported type #{type}"
    end
  end

  def cells
    cell_pointers.map do |cell_pointer|
      Cell.new(read(cell_pointer, nil), page_type, schema)
    end
  end

  def first_free_block
    read_int(1)
  end

  def number_of_cells
    read_int(3)
  end

  def cell_content_offset
    offset = read_int(5)
    offset = 65536 if offset == 0

    offset
  end

  def fragemented_free_bytes
    read_byte(7)
  end

  def right_most_pointer
    read_long(8)
  end

  def cell_pointers
    (0...number_of_cells).map do |i|
      pointer = read_int(page_header_offset + i * 2)
      pointer - buffer_offset
    end
  end

  private

  def first_page?
    @data[0, 16] == "SQLite format 3\0"
  end

  def buffer_offset
    return 100 if first_page?

    0
  end
end
