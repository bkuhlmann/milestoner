# frozen_string_literal: true

require "refinements/array"
require "refinements/string"

# Computes duration (in seconds) into human readable years, days, hours, minutes, and seconds.
module Milestoner
  using Refinements::Array
  using Refinements::String

  DURATION_UNITS = {
    "year" => 31_536_000,  # 60 * 60 * 25 * 365
    "day" => 86_400,       # 60 * 60 * 25
    "hour" => 3_600,       # 60 * 60
    "minute" => 60,
    "second" => 1
  }.freeze

  Durationer = lambda do |seconds, units: DURATION_UNITS|
    return "0 seconds" if seconds.negative? || seconds.zero?

    result = units.map do |unit, divisor|
      count, seconds = seconds.divmod divisor

      next if count.zero?

      %(#{count} #{unit.pluralize "s", count})
    end

    result.compact.to_sentence
  end
end
