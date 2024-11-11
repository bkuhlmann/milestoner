# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles build output format.
        class Format < Sod::Action
          include Dependencies[:settings]

          description "Set output format."

          on %w[-f --format], argument: "[KIND]", allow: %w[ascii_doc feed markdown stream web]

          default { Container[:settings].build_format }

          def call(kind = default) = settings.build_format = kind
        end
      end
    end
  end
end
