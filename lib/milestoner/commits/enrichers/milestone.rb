# frozen_string_literal: true

module Milestoner
  module Commits
    module Enrichers
      # Enriches a commit milestone based on trailer information.
      class Milestone
        include Milestoner::Import[:input]

        def initialize(key: "Milestone", default: "unknown", **)
          @key = key
          @default = default
          super(**)
        end

        def call(commit) = commit.trailer_value_for(key).value_or(default)

        private

        attr_reader :key, :default
      end
    end
  end
end
