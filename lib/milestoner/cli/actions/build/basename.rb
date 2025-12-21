# frozen_string_literal: true

require "sod"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles output path.
        class Basename < Sod::Action
          include Dependencies[:settings]

          description "Set basename."

          ancillary "The file extension is dynamically calculated from format."

          on %w[-b --basename], argument: "[NAME]"

          default { Container[:settings].build_basename }

          def call(name = default) = settings.build_basename = name
        end
      end
    end
  end
end
