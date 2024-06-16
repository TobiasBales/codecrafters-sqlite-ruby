# typed: false
# frozen_string_literal: true

module BufferBacked
  def buffer_offset
    0
  end

  def read(offset, size)
    return @data[buffer_offset + offset..] unless size

    @data[buffer_offset + offset, size]
  end

  def read_string(offset, length)
    read(offset, length)
  end

  def read_byte(offset)
    read(offset, 1).unpack1("C")
  end

  def read_bytes(offset, length)
    read(offset, length).unpack("C*")
  end

  def read_int(offset)
    read(offset, 2).unpack1("n")
  end

  def read_long(offset)
    read(offset, 4).unpack1("N")
  end

  def read_varint(offset)
    first_byte = read_byte(offset)
    return first_byte if first_byte < 0x80

    second_byte = read_byte(offset + 1)
    (first_byte & 0x7f) << 8 | second_byte
  end

  def varint_size(varint)
    return 2 if varint >= 0x80

    1
  end
end
