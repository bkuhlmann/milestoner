# frozen_string_literal: true

module Milestoner
  module Commits
    module Enrichers
      # Enriches a commit issue based on trailer information.
      class Issue
        include Milestoner::Import[:input]

        def initialize(key: "Issue", model: Models::Link, **)
          @key = key
          @model = model
          super(**)
        end

        def call commit
          commit.trailer_value_for(key)
                .fmap { |value| model[id: value, uri: format(input.tracker_uri, id: value)] }
                .value_or(model.new)
        end

        private

        attr_reader :key, :model
      end
    end
  end
end
