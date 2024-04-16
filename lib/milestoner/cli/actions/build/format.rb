# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles build output format.
        class Format < Sod::Action
          include Import[:settings]

          description "Set output format."

          on %w[-f --format], argument: "[KIND]", allow: %w[ascii_doc feed markdown stream web]

          default { Container[:settings].build_format }

          def call(kind = nil) = settings.build_format = kind || default
        end
      end
    end
  end
end
