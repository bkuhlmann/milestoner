# frozen_string_literal: true

require "dry/monads"

module Milestoner
  module Configuration
    module Transformers
      module Generator
        # Conditionally updates generator URI based on gem specification.
        class URI
          include Dependencies[:specification]
          include Dry::Monads[:result]

          def initialize(key = :generator_uri, **)
            super(**)
            @key = key
          end

          def call attributes
            attributes.fetch(key) { attributes.merge! key => specification.homepage_url }
            Success attributes
          end

          private

          attr_reader :key
        end
      end
    end
  end
end
