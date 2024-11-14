# frozen_string_literal: true

require "dry/monads"
require "pathname"

module Milestoner
  module Configuration
    module Transformers
      module Gems
        # Conditionally updates project label based on specification label.
        class Label
          include Import[:spec_loader]
          include Dry::Monads[:result]

          def initialize(key = :project_label, path: "#{Pathname.pwd.basename}.gemspec", **)
            super(**)
            @key = key
            @path = path
          end

          def call attributes
            attributes.fetch key do
              value = spec_loader.call(path).label
              attributes.merge! key => value unless value == "Undefined"
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
