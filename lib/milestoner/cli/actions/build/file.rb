# frozen_string_literal: true

require "pathname"
require "sod"

module Milestoner
  module CLI
    module Actions
      module Build
        # Handles output path.
        class File < Sod::Action
          include Import[:settings]

          description "Set file name."

          ancillary "The extension is dynamically calculated from format."

          on %w[-n --file], argument: "[NAME]"

          default { Container[:settings].build_file }

          def call(name = nil) = settings.build_file = name || default
        end
      end
    end
  end
end
