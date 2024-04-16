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
            @key = key
            super(**)
          end

          def call content
            content.fetch(key) { specification.label }
                   .then { |value| Success content.merge!(key => value) }
          end

          private

          attr_reader :key
        end
      end
    end
  end
end
