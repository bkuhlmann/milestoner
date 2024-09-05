# frozen_string_literal: true

require "cff"
require "dry/monads"
require "pathname"

module Milestoner
  module Configuration
    module Transformers
      module Citations
        # Conditionally updates project description based on citation details.
        class Description
          include Dry::Monads[:result]

          def initialize key = :project_description,
                         path: Pathname.pwd.join("CITATION.cff"),
                         citation: CFF::File
            @key = key
            @path = path
            @citation = citation
          end

          def call attributes
            attributes.fetch key do
              value = citation.open(path).abstract
              attributes.merge! key => value unless value.empty?
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
