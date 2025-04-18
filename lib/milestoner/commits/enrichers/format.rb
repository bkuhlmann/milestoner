# frozen_string_literal: true

module Milestoner
  module Commits
    module Enrichers
      # Enriches a commit format based on trailer information.
      class Format
        include Milestoner::Dependencies[:settings]

        def initialize(key: "Format", **)
          super(**)
          @key = key
        end

        def call(commit) = commit.trailer_value_for(key).value_or(settings.commit_format)

        private

        attr_reader :key
      end
    end
  end
end
