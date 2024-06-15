# typed: false
# frozen_string_literal: true

module BufferBacked
  def buffer_offset
    0
  end

  def data(offset, size)
    @data[buffer_offset + offset, size]
  end

  def read_string(offset, length)
    data(offset, length)
  end

  def read_byte(offset)
    data(offset, 1).unpack1("C")
  end

  def read_bytes(offset, length)
    data(offset, length).unpack("C*")
  end

  def read_int(offset)
    data(offset, 2).unpack1("n")
  end

  def read_long(offset)
    data(offset, 4).unpack1("N")
  end
end
