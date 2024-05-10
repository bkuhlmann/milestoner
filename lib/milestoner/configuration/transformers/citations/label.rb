# frozen_string_literal: true

require "cff"
require "dry/monads"
require "pathname"
require "refinements/hash"

module Milestoner
  module Configuration
    module Transformers
      module Citations
        # Conditionally updates project label based on citation details.
        class Label
          include Dry::Monads[:result]

          using Refinements::Hash

          def initialize key = :project_label,
                         path: Pathname.pwd.join("CITATION.cff"),
                         citation: CFF::File
            @key = key
            @path = path
            @citation = citation
          end

          def call attributes
            attributes.fetch_value(key) { citation.open(path).title }
                      .then { |value| value unless String(value).empty? }
                      .then { |value| Success attributes.merge!(key => value) }
          end

          private

          attr_reader :key, :path, :citation
        end
      end
    end
  end
end
