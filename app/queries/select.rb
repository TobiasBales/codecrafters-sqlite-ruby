# typed: strict
# frozen_string_literal: true

module Queries
  class Select
    def initialize(table, columns)
      @table = table
      @columns = columns
    end

    def execute(pages)
      table_cell = pages.first.table_cell(@table)
      raise "Could not find table #{@table}" unless table_cell

      table_root_page = table_cell.record[:root_page]

      root_page = pages[table_root_page - 1]
      root_page.cells.map do |cell|
        @columns.map do |column|
          cell.record[column]
        end.join("|")
      end
    end
  end
end
