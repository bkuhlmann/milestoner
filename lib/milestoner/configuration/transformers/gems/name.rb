# frozen_string_literal: true

require "dry/monads"
require "pathname"
require "spek"

module Milestoner
  module Configuration
    module Transformers
      module Gems
        # Conditionally updates project name based on specification name.
        class Name
          include Import[:spec_loader]
          include Dry::Monads[:result]

          def initialize(key = :project_name, path: "#{Pathname.pwd.basename}.gemspec", **)
            @key = key
            @path = path
            super(**)
          end

          def call content
            content.fetch(key) { spec_loader.call(path).name }
                   .then { |value| Success content.merge!(key => value) }
          end

          private

          attr_reader :key, :path
        end
      end
    end
  end
end
