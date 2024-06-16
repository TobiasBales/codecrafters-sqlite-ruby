# typed: strict
# frozen_string_literal: true

module Queries
  class Select
    def initialize(table, columns, conditions)
      @table = table
      @columns = columns
      @conditions = conditions
    end

    def execute(pages)
      table_cell = pages.first.table_cell(@table)
      raise "Could not find table #{@table}" unless table_cell

      table_root_page = table_cell.record[:root_page]

      root_page = pages[table_root_page - 1]
      root_page.cells.filter do |cell|
        matches?(cell)
      end.map do |cell|
        @columns.map do |column|
          cell.record[column]
        end.join("|")
      end
    end

    def matches?(cell)
      return true unless @conditions

      key = @conditions.first.to_sym
      value = @conditions[1]

      cell.record[key] == value
    end
  end
end
