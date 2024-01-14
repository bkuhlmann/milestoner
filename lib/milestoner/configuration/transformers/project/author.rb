# frozen_string_literal: true

require "dry/monads"
require "refinements/hash"

module Milestoner
  module Configuration
    module Transformers
      module Project
        # Conditionally updates author based on Git user.
        class Author
          include Import[:git]
          include Dry::Monads[:result]

          using Refinements::Hash

          def initialize(key = :project_author, **)
            @key = key
            super(**)
          end

          def call content
            content.fetch_value(key) { git.get("user.name", nil).value_or(nil) }
                   .then { |value| Success content.merge!(key => value) }
          end

          private

          attr_reader :key
        end
      end
    end
  end
end
