# frozen_string_literal: true

require "pathname"
require "sod"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles output path.
        class Basename < Sod::Action
          include Import[:settings]

          description "Set basename."

          ancillary "The file extension is dynamically calculated from format."

          on %w[-b --basename], argument: "[NAME]"

          default { Container[:settings].build_basename }

          def call(name = nil) = settings.build_basename = name || default
        end
      end
    end
  end
end
