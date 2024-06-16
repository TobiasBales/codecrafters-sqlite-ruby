# typed: strict
# frozen_string_literal: true

class QueryParser
  SELECT_COUNT_REGEX = /^SELECT COUNT\(\*\) FROM (?<table>.*)$/i
  SELECT_REGEX = /^SELECT (?<columns>[a-zA-Z\-_, ].+?) FROM (?<table>[a-zA-Z\-_]+)( WHERE (?<where>.*))?$/i

  class << self
    def parse(query)
      case query
      when SELECT_COUNT_REGEX
        return Queries::Count.new(Regexp.last_match[:table])
      when SELECT_REGEX
        table = Regexp.last_match[:table]

        columns = Regexp.last_match[:columns].split(",").map(&:strip).map(&:to_sym)

        where = Regexp.last_match[:where]
        conditions = where.split("=").map { |c| c.gsub("'", "").strip } if where

        return Queries::Select.new(table, columns, conditions)
      else
        raise "Got unsupported query #{query}"
      end
    end
  end
end
