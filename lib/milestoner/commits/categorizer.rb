# frozen_string_literal: true

require "versionaire"

module Milestoner
  module Commits
    # Retrieves and categorizes Git repository commit tagged or untagged history.
    class Categorizer
      def initialize expression: Regexp, container: Container
        @expression = expression
        @container = container
      end

      def call configuration = CLI::Configuration::Loader.call
        prefixes = configuration.git_commit_prefixes

        prefixes.reduce({}) { |group, prefix| group.merge prefix => [] }
                .merge("Unknown" => [])
                .then { |groups| group_by_prefix prefixes, groups }
                .each_value { |commits| commits.sort_by!(&:subject) }
                .values
                .flatten
                .uniq(&:subject)
      end

      private

      attr_reader :expression, :container

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

      def computed_commits = repository.tagged? ? tagged_commits : saved_commits

      def tagged_commits = repository.commits("#{repository.tag_last}..HEAD")

      def saved_commits = repository.commits

      def repository = container[__method__]
    end
  end
end
