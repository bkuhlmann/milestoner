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

          def call(content) = Success process(content)

          private

          attr_reader :key, :path, :citation

          def process content
            content.fetch(key) { citation.open(path).abstract }
                   .then { |value| String(value).empty? ? content : content.merge!(key => value) }
          end
        end
      end
    end
  end
end
