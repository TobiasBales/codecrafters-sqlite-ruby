# typed: strict
# frozen_string_literal: true

module Queries
  class Select
    def initialize(table, column)
      @table = table
      @column = column
    end

    def execute(pages)
      table_cell = pages.first.table_cell(@table)
      raise "Could not find table #{@table}" unless table_cell

      table_root_page = table_cell.record[:root_page]

      root_page = pages[table_root_page - 1]
      root_page.cells.map { |cell| cell.record[@column] }
    end
  end
end
