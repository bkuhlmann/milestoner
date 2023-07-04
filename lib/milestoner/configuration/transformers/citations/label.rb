# frozen_string_literal: true

require "cff"
require "dry/monads"
require "pathname"

module Milestoner
  module Configuration
    module Transformers
      module Citations
        # Conditionally updates project label based on citation details.
        class Label
          include Dry::Monads[:result]

          def initialize key = :project_label,
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
            content.fetch(key) { citation.open(path).title }
                   .then { |value| String(value).empty? ? content : content.merge!(key => value) }
          end
        end
      end
    end
  end
end
