# typed: strict
# frozen_string_literal: true

class QueryParser
  SELECT_COUNT_REGEX = /^SELECT COUNT\(\*\) FROM (?<table>.*)$/i
  SELECT_SINGLE_COLUMN_REGEX = /^SELECT (?<column>[a-zA-Z\-_].+?) FROM (?<table>.*)$/i

  class << self
    def parse(query)
      case query
      when SELECT_COUNT_REGEX
        return Queries::Count.new(Regexp.last_match[:table])
      when SELECT_SINGLE_COLUMN_REGEX
        return Queries::Select.new(Regexp.last_match[:table], Regexp.last_match[:column].to_sym)
      else
        raise "Got unsupported query #{query}"
      end
    end
  end
end
