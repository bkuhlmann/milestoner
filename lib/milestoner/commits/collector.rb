# frozen_string_literal: true

require "dry/monads"

module Milestoner
  module Commits
    # Collects commits since last tag, a specific range, or all commits if untagged.
    class Collector
      include Dry::Monads[:result]
      include Dependencies[:git]

      MIN = :last
      MAX = :HEAD

      def call(min: MIN, max: MAX) = git.tagged? ? slice(min, max) : all

      private

      def slice min, max
        case [min, max]
          in MIN, MAX then git.tag_last.bind { |tag| git.commits "#{tag}..#{max}" }
          in String, String then git.commits "#{min}..#{max}"
          in nil, String then git.commits max
          else Failure "Invalid minimum and/or maximum range: #{min}..#{max}."
        end
      end

      def all = git.commits
    end
  end
end
