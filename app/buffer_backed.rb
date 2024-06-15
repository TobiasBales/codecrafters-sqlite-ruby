# typed: false
# frozen_string_literal: true

module BufferBacked
  def buffer_offset
    0
  end

  def data(offset, size)
    @data[buffer_offset + offset, size]
  end

  def int_at(offset)
    data = data(offset, 2).unpack1("n")
    raise "Failed to read int from #{offset}" unless data

    data
  end
end
