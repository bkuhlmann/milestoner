# frozen_string_literal: true

require "dry/monads"

module Milestoner
  module Configuration
    module Transformers
      module Generator
        # Conditionally updates generator label based on gem specification.
        class Label
          include Import[:specification]
          include Dry::Monads[:result]

          def initialize(key = :generator_label, **)
            super(**)
            @key = key
          end

          def call attributes
            attributes.fetch(key) { attributes.merge! key => specification.label }
            Success attributes
          end

          private

          attr_reader :key
        end
      end
    end
  end
end
