# frozen_string_literal: true

require "dry/monads"

module Milestoner
  module Configuration
    module Transformers
      module Project
        # Conditionally updates version based on last Git tag.
        class Version
          include Dry::Monads[:result]

          def initialize key = :project_version, versioner: Commits::Versioner.new
            @key = key
            @versioner = versioner
          end

          def call content
            content.fetch(key) { versioner.call }
                   .then { |value| content.merge! key => value }
                   .then { |update| Success update }
          end

          private

          attr_reader :key, :versioner
        end
      end
    end
  end
end
