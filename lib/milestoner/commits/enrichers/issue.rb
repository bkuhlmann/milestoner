# frozen_string_literal: true

module Milestoner
  module Commits
    module Enrichers
      # Enriches a commit issue based on trailer information.
      class Issue
        include Milestoner::Import[:settings]

        def initialize(key: "Issue", model: Models::Link, **)
          super(**)
          @key = key
          @model = model
        end

        def call commit
          uri = settings.tracker_uri

          commit.trailer_value_for(key)
                .either -> value { model[id: value, uri: format(uri, id: value)] },
                        proc { model[id: "All", uri: format(uri, id: nil)] }
        end

        private

        attr_reader :key, :model
      end
    end
  end
end
