# frozen_string_literal: true

require "refinements/array"
require "refinements/string"

# Computes duration (in seconds) into human readable days, hours, minutes, and seconds.
module Milestoner
  using Refinements::Array
  using Refinements::String

  DURATION_UNITS = {"second" => 60, "minute" => 60, "hour" => 24, "day" => 86_400}.freeze

  Durationer = lambda do |seconds, units: DURATION_UNITS|
    result = units.map do |unit, value|
      next unless seconds.positive?

      seconds, number = seconds.divmod value
      number = number.to_i

      %(#{number} #{unit.pluralize "s", number}) if number.nonzero?
    end

    result.compact.reverse.to_sentence
  end
end
