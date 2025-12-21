# frozen_string_literal: true

require "cff"
require "dry/monads"

module Milestoner
  module Configuration
    module Transformers
      module Citations
        # Conditionally updates project URI based on citation URL.
        class URI
          include Dry::Monads[:result]

          def initialize key = :project_uri,
                         path: Pathname.pwd.join("CITATION.cff"),
                         citation: CFF::File
            @key = key
            @path = path
            @citation = citation
          end

          def call attributes
            process attributes
            Success attributes
          rescue KeyError => error
            Failure step: :transform,
                    payload: "Unable to transform #{key.inspect}, missing specifier: " \
                             "\"#{error.message[/<.+>/]}\"."
          end

          private

          attr_reader :key, :path, :citation

          def process attributes
            attributes.fetch(key) { citation.open(path).url }
                      .then { |value| value.match?(/%<.+>s/) ? format(value, attributes) : value }
                      .then { |value| attributes.merge! key => value unless value.empty? }
          end
        end
      end
    end
  end
end
