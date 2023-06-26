# frozen_string_literal: true

require "refinements/arrays"
require "versionaire"

module Milestoner
  module Commits
    # Retrieves and categorizes Git repository commit tagged or untagged history.
    class Categorizer
      include Import[:git]

      using Refinements::Arrays

      def initialize(expression: Regexp, **)
        super(**)
        @expression = expression
      end

      def call configuration = Container[:configuration]
        prefixes = configuration.commit_categories.pluck :label

        prefixes.reduce({}) { |group, prefix| group.merge prefix => [] }
                .merge("Unknown" => [])
                .then { |groups| group_by_prefix prefixes, groups }
                .each_value { |commits| commits.sort_by!(&:subject) }
                .values
                .flatten
                .uniq(&:subject)
      end

      private

      attr_reader :expression

      def group_by_prefix prefixes, groups
        computed_commits.each.with_object groups do |commit, collection|
          prefix = commit.subject[subject_pattern(prefixes)]
          key = collection.key?(prefix) ? prefix : "Unknown"
          collection[key] << commit
        end
      end

      def subject_pattern prefixes
        prefixes.empty? ? expression.new(//) : expression.union(prefixes)
      end

      def computed_commits = git.tagged? ? tagged_commits : saved_commits

      def tagged_commits
        git.tag_last
           .value_or(nil)
           .then { |tag| git.commits "#{tag}..HEAD" }
           .value_or([])
      end

      def saved_commits = git.commits.value_or([])
    end
  end
end
