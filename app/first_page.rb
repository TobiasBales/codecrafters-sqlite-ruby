# typed: strict
# frozen_string_literal: true

class FirstPage < Page
  def initialize(data)
    super(data, [:type, :name, :table_name, :root_page, :sql])
  end

  def table_cell(table_name)
    cells.find { |cell| cell.record[:table_name] == table_name }
  end
end
