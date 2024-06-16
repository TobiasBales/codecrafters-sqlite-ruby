# typed: strict
# frozen_string_literal: true

class SchemaParser
  CREATE_TABLE_REGEX = /^CREATE TABLE (?<table>[a-z_-]+).*\((?<fields>.+?)\)$/im
  class << self
    def parse(sql)
      match = CREATE_TABLE_REGEX.match(sql)
      raise "Did not find create table statement in #{sql}" unless match

      fields = match[:fields].split(",").map do |field|
        field.split(" ").first.strip.to_sym
      end
      [match[:table], fields]
    end
  end
end
