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

          def call attributes
            attributes.fetch(key) { specification.homepage_url }
                      .then { |value| Success attributes.merge!(key => value) }
          end

          private

          attr_reader :key
        end
      end
    end
  end
end
