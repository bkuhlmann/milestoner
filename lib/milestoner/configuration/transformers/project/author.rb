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

          def call attributes
            attributes.fetch key do
              git.get("user.name", nil).bind { |value| attributes.merge! key => value if value }
            end

            Success attributes
          end

          private

          attr_reader :key
        end
      end
    end
  end
end
