# frozen_string_literal: true

module Milestoner
  module Commits
    module Enrichers
      # Enriches a commit review based on trailer information.
      class Review
        include Milestoner::Import[:input]

        def initialize(model: Models::Link, **)
          @model = model
          super(**)
        end

        def call(*) = model[id: "All", uri: format(input.review_uri, id: nil)]

        private

        attr_reader :model
      end
    end
  end
end
