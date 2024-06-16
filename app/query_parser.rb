# typed: strict
# frozen_string_literal: true

class QueryParser
  SELECT_COUNT_REGEX = /^SELECT COUNT\(\*\) FROM (?<table>.*)$/i

  class << self
    def parse(query)
      case query
      when SELECT_COUNT_REGEX
        return Queries::Count.new(Regexp.last_match[:table])
      else
        raise "Got unsupported query #{query}"
      end
    end
  end
end
