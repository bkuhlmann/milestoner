# frozen_string_literal: true

require "dry/monads"
require "refinements/hash"

module Milestoner
  module Configuration
    module Transformers
      module Project
        # Conditionally updates version based on last Git tag.
        class Version
          include Dry::Monads[:result]

          using Refinements::Hash

          def initialize key = :project_version, versioner: Commits::Versioner.new
            @key = key
            @versioner = versioner
          end

          def call content
            content.fetch_value(key) { versioner.call }
                   .then { |value| Success content.merge!(key => value) }
          end

          private

          attr_reader :key, :versioner
        end
      end
    end
  end
end
