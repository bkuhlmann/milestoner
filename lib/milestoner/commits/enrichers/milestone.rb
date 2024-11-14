# frozen_string_literal: true

module Milestoner
  module Commits
    module Enrichers
      # Enriches a commit milestone based on trailer information.
      class Milestone
        include Milestoner::Import[:settings]

        def initialize(key: "Milestone", default: "unknown", **)
          super(**)
          @key = key
          @default = default
        end

        def call(commit) = commit.trailer_value_for(key).value_or(default)

        private

        attr_reader :key, :default
      end
    end
  end
end
