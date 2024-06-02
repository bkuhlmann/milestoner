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
            attributes.fetch(key) { attributes.merge!(key => citation.open(path).title).compress! }
            Success attributes
          end

          private

          attr_reader :key, :path, :citation
        end
      end
    end
  end
end
