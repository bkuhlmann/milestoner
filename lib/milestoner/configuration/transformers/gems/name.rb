# frozen_string_literal: true

require "dry/monads"
require "pathname"
require "refinements/hash"

module Milestoner
  module Configuration
    module Transformers
      module Gems
        # Conditionally updates project name based on specification name.
        class Name
          include Import[:spec_loader]
          include Dry::Monads[:result]

          using Refinements::Hash

          def initialize(key = :project_name, path: "#{Pathname.pwd.basename}.gemspec", **)
            @key = key
            @path = path
            super(**)
          end

          def call attributes
            attributes.fetch key do
              attributes.merge!(key => spec_loader.call(path).name).compress!
            end

            Success attributes
          end

          private

          attr_reader :key, :path
        end
      end
    end
  end
end
