# frozen_string_literal: true

require "refinements/array"
require "versionaire"

module Milestoner
  module Commits
    # Retrieves and categorizes Git repository commit tagged or untagged history.
    class Categorizer
      include Import[:git]

      using Refinements::Array

      def initialize(collector: Collector.new, expression: Regexp, **)
        @collector = collector
        @expression = expression
        super(**)
      end

      def call configuration = Container[:configuration]
        categories = configuration.commit_categories.pluck :label

        categories.reduce({}) { |group, prefix| group.merge prefix => [] }
                  .merge("Unknown" => [])
                  .then { |groups| group_by_category categories, groups }
                  .each_value { |commits| commits.sort_by!(&:subject) }
                  .values
                  .flatten
                  .uniq(&:subject)
      end

      private

      attr_reader :collector, :expression

      def group_by_category categories, groups
        collector.call.value_or([]).each.with_object groups do |commit, collection|
          category = commit.subject[subject_pattern(categories)]
          key = collection.key?(category) ? category : "Unknown"
          collection[key] << commit
        end
      end

      def subject_pattern categories
        categories.empty? ? expression.new(//) : expression.union(categories)
      end
    end
  end
end
