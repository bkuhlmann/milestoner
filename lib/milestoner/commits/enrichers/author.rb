# frozen_string_literal: true

module Milestoner
  module Commits
    module Enrichers
      # Enriches a commit author by using cache.
      class Author
        include Milestoner::Import[:cache]

        def initialize(model: Models::User, **)
          @model = model
          super(**)
        end

        def call commit
          cache.read(:users) { |table| table.find commit.author_name }
               .value_or(model.new)
        end

        private

        attr_reader :model
      end
    end
  end
end
