# frozen_string_literal: true

require "dry/monads"
require "pathname"
require "spek"

module Milestoner
  module Configuration
    module Transformers
      module Gems
        # Conditionally updates project description based on specification summary.
        class Description
          include Import[:spec_loader]
          include Dry::Monads[:result]

          def initialize(key = :project_description, path: "#{Pathname.pwd.basename}.gemspec", **)
            @key = key
            @path = path
            super(**)
          end

          def call(content) = Success process(content)

          private

          attr_reader :key, :path

          def process content
            content.fetch(key) { spec_loader.call(path).summary }
                   .then { |value| String(value).empty? ? content : content.merge!(key => value) }
          end
        end
      end
    end
  end
end
