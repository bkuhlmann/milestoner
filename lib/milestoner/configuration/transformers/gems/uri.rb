# frozen_string_literal: true

require "dry/monads"
require "pathname"

module Milestoner
  module Configuration
    module Transformers
      module Gems
        # Conditionally updates project URI based on specification home page URL.
        class URI
          include Import[:spec_loader]
          include Dry::Monads[:result]

          def initialize(key = :project_uri, path: "#{Pathname.pwd.basename}.gemspec", **)
            @key = key
            @path = path
            super(**)
          end

          def call content
            content.fetch(key) { spec_loader.call(path).homepage_url }
                   .then { |value| value unless String(value).empty? }
                   .then { |value| Success content.merge!(key => value) }
          end

          private

          attr_reader :key, :path
        end
      end
    end
  end
end
