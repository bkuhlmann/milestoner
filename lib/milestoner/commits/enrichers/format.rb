# frozen_string_literal: true

module Milestoner
  module Commits
    module Enrichers
      # Enriches a commit format based on trailer information.
      class Format
        include Milestoner::Import[:input]

        def initialize(key: "Format", **)
          @key = key
          super(**)
        end

        def call(commit) = commit.trailer_value_for(key).value_or(input.commit_format)

        private

        attr_reader :key
      end
    end
  end
end
