# frozen_string_literal: true

require "dry/monads"

module Milestoner
  module Configuration
    module Transformers
      module Generator
        # Conditionally updates generator URI based on gem specification.
        class URI
          include Import[:specification]
          include Dry::Monads[:result]

          def initialize(key = :generator_uri, **)
            @key = key
            super(**)
          end

          def call content
            content.fetch(key) { specification.homepage_url }
                   .then { |value| Success content.merge!(key => value) }
          end

          private

          attr_reader :key
        end
      end
    end
  end
end
