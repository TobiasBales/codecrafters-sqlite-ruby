# typed: false
# frozen_string_literal: true

module Commands
  class Tables
    def initialize(header, pages)
      @header = header
      @pages = pages
    end

    def generate
      table_names = @pages.first.cells
        .map { |c| c.record[:table_name] }
        .reject { |t| t == "sqlite_sequence" }

      maximum_length = table_names.max_by(&:length).length

      table_names.map { |t| t.ljust(maximum_length) }.join(" ")
    end
  end
end
