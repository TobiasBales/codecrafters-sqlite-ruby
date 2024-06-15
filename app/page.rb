# typed: false
# frozen_string_literal: true

class Page
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def type

  end

  def page_type
    case @type
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

  def number_of_cells
    int_at(3)
  end

  private

  def first_page?
    data[0, 16] == "SQLite format 3\0"
  end

  def btree_offset
    return 100 if first_page?

    0
  end

  def read_from(offset, size)
    @data[btree_offset + offset, size]
  end

  def int_at(offset)
    data = read_from(offset, 2).unpack1("n")
    raise "Failed to read int from #{offset}" unless data

    data
  end
end
