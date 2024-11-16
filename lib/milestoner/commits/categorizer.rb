# frozen_string_literal: true

require "core"
require "refinements/array"

module Milestoner
  module Commits
    # Retrieves and categorizes Git repository commit tagged or untagged history.
    class Categorizer
      include Dependencies[:settings]

      using Refinements::Array

      def initialize(collector: Collector.new, **)
        super(**)

        @collector = collector
        @labels = settings.commit_categories.pluck :label
        @pattern = labels.empty? ? // : Regexp.union(labels)
      end

      # :reek:NestedIterators
      def call min: Collector::MIN, max: Collector::MAX
        collect(min, max).each_value { |commits| commits.sort_by! { |_, commit| commit.subject } }
                         .values
                         .reduce(&:concat)
      end

      private

      attr_reader :collector, :labels, :pattern

      def collect min, max
        collector.call(min:, max:)
                 .value_or(Core::EMPTY_ARRAY)
                 .each
                 .with_index(1)
                 .with_object categories do |(commit, position), collection|
                   category = commit.subject[pattern]
                   key = collection.key?(category) ? category : "Unknown"
                   collection[key] << [position, commit]
                 end
      end

      def categories
        labels.reduce({}) { |group, prefix| group.merge prefix => [] }
              .merge! "Unknown" => []
      end
    end
  end
end
