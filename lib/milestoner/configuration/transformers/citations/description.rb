# frozen_string_literal: true

require "cff"
require "dry/monads"
require "pathname"
require "refinements/hash"

module Milestoner
  module Configuration
    module Transformers
      module Citations
        # Conditionally updates project description based on citation details.
        class Description
          include Dry::Monads[:result]

          using Refinements::Hash

          def initialize key = :project_description,
                         path: Pathname.pwd.join("CITATION.cff"),
                         citation: CFF::File
            @key = key
            @path = path
            @citation = citation
          end

          def call attributes
            attributes.fetch key do
              attributes.merge!(key => citation.open(path).abstract).compress!
            end

            Success attributes
          end

          private

          attr_reader :key, :path, :citation
        end
      end
    end
  end
end
