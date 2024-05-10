# frozen_string_literal: true

require "dry/monads"

module Milestoner
  module Configuration
    module Transformers
      module Project
        # Conditionally updates generator based on gem specification.
        class Generator
          include Import[:specification]
          include Dry::Monads[:result]

          def initialize(key = :project_generator, **)
            @key = key
            super(**)
          end

          def call attributes
            warn "`#{self.class}##{__method__}` is deprecated, use " \
                 "`Milestoner::Configuration::Transformers::Generator::Label` or " \
                 "`Milestoner::Configuration::Transformers::Generator::URI` instead.",
                 category: :deprecated

            Success({key => specification.labeled_version}.merge!(attributes))
          end

          private

          attr_reader :key
        end
      end
    end
  end
end
