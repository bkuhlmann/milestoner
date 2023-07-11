# frozen_string_literal: true

require "dry/monads"

module Milestoner
  module Configuration
    module Transformers
      module Project
        # Conditionally updates author based on Git user.
        class Author
          include Import[:git]
          include Dry::Monads[:result]

          def initialize(key = :project_author, **)
            @key = key
            super(**)
          end

          def call content
            content.fetch(key) { git.get("user.name", nil).value_or(nil) }
                   .tap { |value| content[key] = value if value }

            Success content
          end

          private

          attr_reader :key
        end
      end
    end
  end
end
