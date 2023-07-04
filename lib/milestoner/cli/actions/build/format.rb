# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles build output format.
        class Format < Sod::Action
          include Import[:input]

          description "Set output format."

          on %w[-f --format], argument: "[KIND]", allow: %w[stream web]

          default { Container[:configuration].build_format }

          def call(kind = nil) = input.build_format = kind || default
        end
      end
    end
  end
end
