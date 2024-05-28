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

          def call attributes
            process attributes
            Success attributes
          rescue KeyError => error
            Failure step: :transform,
                    payload: "Unable to transform #{key.inspect}, missing specifier: " \
                             "\"#{error.message[/<.+>/]}\"."
          end

          private

          attr_reader :key, :path

          def process attributes
            attributes.fetch(key) { spec_loader.call(path).homepage_url }
                      .then { |value| value.match?(/%<.+>s/) ? format(value, attributes) : value }
                      .then { |value| attributes.merge! key => value unless value.empty? }
          end
        end
      end
    end
  end
end
