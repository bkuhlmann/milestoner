# frozen_string_literal: true

module Milestoner
  module Commits
    # Collects commits since last tag or all commits if untagged.
    class Collector
      include Import[:git]

      def call = git.tagged? ? latest : all

      private

      def latest = git.tag_last.bind { |tag| git.commits "#{tag}..HEAD" }

      def all = git.commits
    end
  end
end
